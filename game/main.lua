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
local GLOBAL = require 'global'
local Map    = require 'base.map'
local Player = require 'player'

-- Main globals
-- TODO(Jack): Maybe move debug stuff to its own module, since there's so much of it
DEBUG = true

-- Live code editing library
-- Debug only
if DEBUG then
   lick = require 'lib.lick'
   lick.reset = true
end

-- Debug Draw flags
gDRAWMAP = true
gDRAWGUI = true

-- Helper functions for buffer scale and offset algs
-- TODO(Jack) Move buffer stuff to its own module
function gGetBufferScale(bufferHeight)
   return love.graphics.getHeight()/bufferHeight
end

function gGetBufferOffset(width, scale)
   return {
      x = love.graphics.getWidth()/2 - (width * scale)/2,
      y = 0
   }
end

function gMakeBuffer(width, height)
   local buffer = {}   
   buffer.width  = width
   buffer.height = height
   buffer.canvas = love.graphics.newCanvas(buffer.width, buffer.height)
   buffer.scale  = gGetBufferScale(buffer.canvas:getHeight())
   buffer.offset = gGetBufferOffset(buffer.canvas:getWidth(), buffer.scale)
   return buffer
end

function gUpdateBuffer(buffer, width, height)
   buffer.width  = width
   buffer.height = height
   buffer.scale  = gGetBufferScale(buffer.canvas:getHeight())
   buffer.offset = gGetBufferOffset(buffer.canvas:getWidth(), buffer.scale)
end

gPaused = false

-- Temporary pause function
function gTogglePause()
   if gPaused then gPaused = false
   else gPaused = true end
end

-- Main load
function love.load()
   -- Extra graphics settings
   love.graphics.setDefaultFilter("nearest","nearest")

   -- Load map
   map = Map.new(GLOBAL.MAP_PATH.."test-map.lua")

   -- Load assets
   fntPixel = love.graphics.newFont(GLOBAL.FONT_PATH.."pixelfj.TTF", 8)
   sprCyanPortrait = love.graphics.newImage(GLOBAL.IMAGE_PATH.."static/CyanPortrait.png")
   sprIcons   = love.graphics.newImage(GLOBAL.IMAGE_PATH.."gui/Icons.png")
   sprBars    = love.graphics.newImage(GLOBAL.IMAGE_PATH.."gui/Bar.png")
   sprButtons = love.graphics.newImage(GLOBAL.IMAGE_PATH.."gui/BattleButtons.png")
   
   -- Icon quads
   qIconHeart = love.graphics.newQuad(0, 0, 16, 16, 80, 16)
   qIconPhantomHeart = love.graphics.newQuad(16, 0, 16, 16, 80, 16)
   qIconCoin  = love.graphics.newQuad(32, 0, 16, 16, 80, 16)
   qIconBomb  = love.graphics.newQuad(48, 0, 16, 16, 80, 16)
   qIconKey   = love.graphics.newQuad(64, 0, 16, 16, 80, 16)

   -- Button quads
   qButtonBattle= love.graphics.newQuad(0, 0, 16, 16, 80, 16)
   qButtonSmile = love.graphics.newQuad(16, 0, 16, 16, 80, 16)
   qButtonTalk  = love.graphics.newQuad(32, 0, 16, 16, 80, 16)
   qButtonBribe = love.graphics.newQuad(48, 0, 16, 16, 80, 16)
   qButtonRun   = love.graphics.newQuad(64, 0, 16, 16, 80, 16)

   -- Set cursor
   imgCursor = love.graphics.newImage(GLOBAL.IMAGE_PATH.."gui/Cursor.png")
   Cursor = love.mouse.newCursor(imgCursor:getData(), imgCursor:getWidth()/2, imgCursor:getHeight()/2)
   love.mouse.setCursor(Cursor)
   
   -- Drawing canvases
   FrameBuffer = gMakeBuffer(GLOBAL.PIXEL_WIDTH, GLOBAL.PIXEL_HEIGHT)
   GUIBuffer = gMakeBuffer(GLOBAL.GUI_PIXEL_WIDTH, GLOBAL.GUI_PIXEL_HEIGHT)

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
	 if gDRAWGUI then gDRAWGUI = false
	 else gDRAWGUI = true end
      end

      if key == 'f2' then
	 if gDRAWMAP then gDRAWMAP = false
	 else gDRAWMAP = true end
      end
   end

   -- Pause
   if key == 'p' or key == 'tab' then
      gTogglePause()
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

-- Main joystick button press
function love.joystickpressed(joystick, button)
   -- Pause on select button pressed
   if button == 7 then
      gTogglePause()
   end
end

-- Main Update
function love.update(dt)
   GLOBAL.WINDOW_WIDTH = love.graphics.getWidth()
   GLOBAL.WINDOW_HEIGHT = love.graphics.getHeight()

   -- Update frame buffer based on current window state
   gUpdateBuffer(FrameBuffer, GLOBAL.PIXEL_WIDTH, GLOBAL.PIXEL_HEIGHT)
   gUpdateBuffer(GUIBuffer, GLOBAL.GUI_PIXEL_WIDTH, GLOBAL.GUI_PIXEL_HEIGHT)

   -- Everything past here should be affected by pause
   if gPaused then return end

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
   map.sti:setDrawRange(-cyanpos.x, -cyanpos.y, GLOBAL.WINDOW_WIDTH, GLOBAL.WINDOW_HEIGHT)

   if gDRAWMAP then
      map:draw()
   end
   
   -- Draw game
   Cyan:Draw()

   -- Draw debug
   if DEBUG then
      love.graphics.setFont(fntPixel)
      Cyan:DrawDebug()
   end
   Camera.unset()
   
   -- Draw ui (just proof of concept, doesn't actually do anything)
   -- TODO(Jack): Draw GUI elements to their own canvas
   if gDRAWGUI then
      love.graphics.setCanvas(GUIBuffer.canvas)
      love.graphics.clear()

      -- Status bars
      local barWidth = sprBars:getWidth()
      local lifeColor = {r=255, g=45, b=72}
      local powerColor = {r=72, g=76, b=255}
      love.graphics.setColor(lifeColor.r,lifeColor.g,lifeColor.b)
      love.graphics.rectangle("fill", 0, 0, barWidth, 8)
      love.graphics.setColor(powerColor.r,powerColor.g,powerColor.b)
      love.graphics.rectangle("fill", 0, 8, barWidth, 8)
      love.graphics.setColor(255,255,255)
      love.graphics.draw(sprBars, 0, 0)

      -- Buttons
      local btnWidth  = 16
      local btnHeight = sprButtons:getHeight()
      local margin    = 3
      local xOffset   = GLOBAL.GUI_PIXEL_WIDTH/2-btnWidth*5/2-margin*5
      local yOffset   = GLOBAL.GUI_PIXEL_HEIGHT-btnHeight-margin
      love.graphics.setColor(0, 0, 0, 100)
      love.graphics.rectangle("fill", 0, yOffset-2, GLOBAL.GUI_PIXEL_WIDTH, GLOBAL.GUI_PIXEL_HEIGHT)
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(sprButtons, qButtonBattle,btnWidth*0*margin/2+xOffset, yOffset)
      love.graphics.draw(sprButtons, qButtonSmile, btnWidth*1*margin/2+xOffset, yOffset)
      love.graphics.draw(sprButtons, qButtonTalk,  btnWidth*2*margin/2+xOffset, yOffset)
      love.graphics.draw(sprButtons, qButtonBribe, btnWidth*3*margin/2+xOffset, yOffset)
      love.graphics.draw(sprButtons, qButtonRun,   btnWidth*4*margin/2+xOffset, yOffset)
   end
   
   love.graphics.setCanvas()

   -- Draw the frame buffer
   love.graphics.draw(FrameBuffer.canvas,
		      FrameBuffer.offset.x,
		      FrameBuffer.offset.y,
		      0,
		      FrameBuffer.scale,
		      FrameBuffer.scale)

   -- Draw GUI buffer
   if gDRAWGUI then
      love.graphics.setBlendMode("alpha", "premultiplied")
      love.graphics.draw(GUIBuffer.canvas,
			 GUIBuffer.offset.x,
			 GUIBuffer.offset.y,
			 0,
			 GUIBuffer.scale,
			 GUIBuffer.scale)
      love.graphics.setBlendMode("alpha")
   end

   if gPaused then
      love.graphics.setColor(0, 0, 0, 155)
      love.graphics.rectangle("fill", 0, 0, GLOBAL.WINDOW_WIDTH, GLOBAL.WINDOW_HEIGHT)
      love.graphics.setColor(255,255,255,255)
   end
   
   -- Debug info
   if not DEBUG then return end
   local stats = love.graphics.getStats()
   love.graphics.rectangle("line",
			   FrameBuffer.offset.x,
			   FrameBuffer.offset.y,
			   FrameBuffer.canvas:getWidth()*FrameBuffer.scale,
			   FrameBuffer.canvas:getHeight()*FrameBuffer.scale)
   love.graphics.setColor(255, 0, 0, 100)
   love.graphics.rectangle("fill", 5, GLOBAL.WINDOW_HEIGHT-110, 180, 135)
   love.graphics.setColor(255, 255, 255)
   love.graphics.print(string.format("LOVE Ver: %d.%d.%d - %s",love.getVersion()), 10, GLOBAL.WINDOW_HEIGHT-35)
   love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, GLOBAL.WINDOW_HEIGHT-20)
   love.graphics.print(string.format("Draw Calls: %d\nCanvas Switches: %d\nTexture Mem: %.2f MB\nImages: %d\nCanvases: %d\nFonts: %d",
				     stats.drawcalls,
				     stats.canvasswitches,
				     stats.texturememory/1024/1024,
				     stats.images,
				     stats.canvases,
				     stats.fonts), 10, GLOBAL.WINDOW_HEIGHT-100)
end
