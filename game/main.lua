--[[ Copyright (c) 2016 Jack Riales. All Rights Reserved.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

-- Anniversary Quest
-- by Jack Riales
--
-- P.S. If you find yourself reading this, I love you! Happy 9th.
-- I'm actually writing this on August 7th. Pretty crazy right?
-- Anyway, I hope you enjoy.

-- Dependencies
require 'base.camera'
local Player = require 'player'

local Map    = require 'map'
lick = require 'lib.lick'
lick.reset = true

-- Main globals
DEBUG = true
GUI   = true

WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

ASSET_PATH = "assets/"
IMAGE_PATH = ASSET_PATH.."images/"
FONT_PATH  = ASSET_PATH.."fonts/"
MUSIC_PATH = ASSET_PATH.."music/"
MAP_PATH   = "data/map-data/"

-- Main load
function love.load()
   -- Extra graphics settings
   love.graphics.setDefaultFilter("nearest","nearest")

   -- Load map
   map = Map.new(MAP_PATH.."test-map.lua")

   -- Load assets
   fntJoystix = love.graphics.newFont(FONT_PATH.."pixelfj.ttf", 8)
   sprCyanPortrait = love.graphics.newImage(IMAGE_PATH.."static/CyanPortrait.png")
   sprIcons   = love.graphics.newImage(IMAGE_PATH.."gui/Icons.png")
   sprBars    = love.graphics.newImage(IMAGE_PATH.."gui/Bar.png")
   sprButtons = love.graphics.newImage(IMAGE_PATH.."gui/BattleButtons.png")
   
   -- Icon quads
   qIconHeart = love.graphics.newQuad(0, 0, 16, 16, 80, 16)
   qIconPhantomHeart = love.graphics.newQuad(16, 0, 16, 16, 80, 16)
   qIconCoin  = love.graphics.newQuad(32, 0, 16, 16, 80, 16)
   qIconBomb  = love.graphics.newQuad(48, 0, 16, 16, 80, 16)
   qIconKey   = love.graphics.newQuad(64, 0, 16, 16, 80, 16)
   
   -- Set cursor
   imgCursor = love.graphics.newImage(IMAGE_PATH.."gui/Cursor.png")
   Cursor = love.mouse.newCursor(imgCursor:getData(), imgCursor:getWidth()/2, imgCursor:getHeight()/2)
   love.mouse.setCursor(Cursor)
   
   -- Drawing canvas
   FrameBuffer = {}
   FrameBuffer.width  = 256
   FrameBuffer.height = 256
   FrameBuffer.canvas = love.graphics.newCanvas(FrameBuffer.width, FrameBuffer.height)
   FrameBuffer.scale  = love.graphics.getHeight()/FrameBuffer.canvas:getHeight()
   FrameBuffer.offset = {
      x = love.graphics.getWidth()/2 - (FrameBuffer.canvas:getWidth()*FrameBuffer.scale)/2,
      y = 0
   }

   -- Player object loading from definition file
   Cyan = Player.new("data.player-cyan")
   Cyan.entity:SetOrigin(16,32)
   Cyan.entity:SetPosition(64, 64)
end

-- Main input key-pressed
function love.keypressed(key, scancode, isrepeat)
   -- Check for toggle debug (remove on release)
   if key == "`" then
      if DEBUG then DEBUG = false
      else DEBUG = true end
   end

   -- Debug commands
   if DEBUG then
      if key == 'f1' then
	 if GUI then GUI = false
	 else GUI = true end
      end
   end

   -- F11 toggles fullscreen mode
   if key == 'f11' then
      love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
   end

   -- Check for leave
   if key == "escape" then
      local buttons = {"NO!", "Yep!", escapebutton = 1}
      local quit = love.window.showMessageBox("Confirmation",
					      "Are you sure you want to exit?",
					      buttons);
      if (quit == 2) then love.event.push('quit'); end
   end

   -- Player keypress events
   Cyan:KeyPressed(key, scancode, isrepeat, DEBUG)
end

-- Main Update
function love.update(dt)
   WINDOW_WIDTH = love.graphics.getWidth()
   WINDOW_HEIGHT = love.graphics.getHeight()

   -- Update frame buffer based on current window state
   FrameBuffer.canvas = love.graphics.newCanvas(FrameBuffer.width, FrameBuffer.height)
   FrameBuffer.scale  = love.graphics.getHeight()/FrameBuffer.canvas:getHeight()
   FrameBuffer.offset = {
      x = love.graphics.getWidth()/2 - (FrameBuffer.canvas:getWidth()*FrameBuffer.scale)/2,
      y = 0
   }

   map:update(dt)
   Cyan:Update(dt)
   Camera.setPosition(Cyan.entity:GetPosition().x-128, Cyan.entity:GetPosition().y-128)
end

-- Main Draw
function love.draw()
   -- Draw game to canvas
   love.graphics.setCanvas(FrameBuffer.canvas)
   Camera.set()
   love.graphics.clear(50, 100, 75)

   -- Draw map
   local cyanpos = Camera.position
   map.sti:setDrawRange(-cyanpos.x, -cyanpos.y, WINDOW_WIDTH, WINDOW_HEIGHT)
   
   -- Draw game
   Cyan:Draw()

   -- Draw debug
   if DEBUG then
      love.graphics.setFont(fntJoystix)
      Cyan:DrawDebug()
   end
   Camera.unset()
   
   -- Draw ui (just proof of concept, doesn't actually do anything)
   -- TODO(Jack): Draw GUI elements to their own canvas
   if GUI then
      love.graphics.setColor(255,0,0)
      love.graphics.rectangle("fill", 10, 10, sprBars:getWidth(), 8)
      love.graphics.setColor(0,25,255)
      love.graphics.rectangle("fill", 10, 18, sprBars:getWidth(), 8)
      love.graphics.setColor(255,255,255)
      love.graphics.draw(sprBars, 10, 10)
   end
   
   love.graphics.setCanvas()

   -- Draw the frame buffer
   love.graphics.draw(FrameBuffer.canvas,
		      FrameBuffer.offset.x,
		      FrameBuffer.offset.y,
		      0,
		      FrameBuffer.scale,
		      FrameBuffer.scale)
   
   -- Debug info
   if not DEBUG then return end
   love.graphics.rectangle("line",
			   FrameBuffer.offset.x,
			   FrameBuffer.offset.y,
			   FrameBuffer.canvas:getWidth()*FrameBuffer.scale,
			   FrameBuffer.canvas:getHeight()*FrameBuffer.scale)
   
   love.graphics.setColor(0, 255, 0, 100)
   love.graphics.rectangle("fill", 5, 5, 180, 50)
   love.graphics.setColor(255, 255, 255)
   love.graphics.print(string.format("LOVE Ver: %d.%d.%d - %s",love.getVersion()), 10, 10)
   love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 25)
end
