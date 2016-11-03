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
local GLOBAL = require 'global'
local Camera = require 'base.camera'
local Button = require 'base.button'
local Map    = require 'base.map'
local Player = require 'player'

-- Require this module for a debug build
-- Remove on release
local Debug = require 'base.debug'

-- Live code editing library
-- Debug only
if Debug then
   lick = require 'lib.lick'
   lick.reset = true
end

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

   -- Asset references
   local lg = love.graphics
   fntPixel   = lg.newFont(GLOBAL.FONT_PATH.."pixelfj.TTF", 8)
   sprBars    = lg.newImage(GLOBAL.IMAGE_PATH.."gui/Bar.png")
   sprButtons = lg.newImage(GLOBAL.IMAGE_PATH.."gui/BattleButtons.png")
   
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

   -- Testinb buttons...
   myButton = Button.new({x=20, y=20, w=600, h=500}, function() print("hello!") end, function() print("hovering...") end)
end

-- Main input key-pressed
function love.keypressed(key, scancode, isrepeat)
   -- Check for toggle debug (remove on release)
   if key == "`" then
      if Debug.Flags.DRAW_DBG then Debug.Flags.DRAW_DBG = false
      else Debug.Flags.DRAW_DBG = true end
   end

   -- Debug commands
   if Debug then
      if key == 'f1' then
	 if Debug.Flags.DRAW_GUI then Debug.Flags.DRAW_GUI = false
	 else Debug.Flags.DRAW_GUI = true end
      end

      if key == 'f2' then
	 if Debug.Flags.DRAW_MAP then Debug.Flags.DRAW_MAP = false
	 else Debug.Flags.DRAW_MAP = true end
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
   Cyan:KeyPressed(key, scancode, isrepeat, Debug)
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

   myButton:update(dt)
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

   if Debug and Debug.Flags.DRAW_MAP then
      map:draw()
   end
   
   -- Draw game
   Cyan:Draw()

   -- Draw debug
   if Debug.Flags.DRAW_DBG then
      love.graphics.setFont(fntPixel)
      Cyan:DrawDebug()
   end
   Camera.unset()
   
   -- Draw ui (just proof of concept, doesn't actually do anything)
   -- TODO(Jack): Draw GUI elements to their own canvas
   if Debug.Flags.DRAW_GUI then
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
   if Debug.Flags.DRAW_GUI then
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
   if not Debug.Flags.DRAW_DBG then return end
   Debug.Draw()
   love.graphics.rectangle("line",
			   FrameBuffer.offset.x,
			   FrameBuffer.offset.y,
			   FrameBuffer.canvas:getWidth()*FrameBuffer.scale,
			   FrameBuffer.canvas:getHeight()*FrameBuffer.scale)
   myButton:DrawDebug()
end
