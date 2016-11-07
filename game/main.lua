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

-- Dependencies
local AQ     = require 'quest.conf'
local Canvas = require 'engine.graphics.canvas'
local Camera = require 'engine.graphics.camera'
local Map    = require 'engine.graphics.map'
local Button = require 'engine.ui.button'

local Player = require 'quest.player'

-- Remove on Release --
local Debug = {}
Debug.DrawInfo = true
Debug.DrawHelpers = true
Debug.DrawGUI = true
-- Remove on Release --

gPaused = false

-- Main load
function love.load()
   -- Extra graphics settings
   love.graphics.setDefaultFilter("nearest","nearest")

   -- Minimum frame time
   min_dt = 1 / AQ.Framerate;
   next_time = love.timer.getTime()

   -- Load map
   map = Map.new(AQ.MapPath.."test-map.lua")

   -- Asset references
   local lg = love.graphics
   fntPixel   = lg.newFont(AQ.FontPath.."pixelfj.TTF", 8)
   sprBars    = lg.newImage(AQ.ImagePath.."gui/Bar.png")
   sprButtons = lg.newImage(AQ.ImagePath.."gui/BattleButtons.png")

   -- Set cursor
   imgCursor = love.graphics.newImage(AQ.ImagePath.."gui/Cursor.png")
   Cursor = love.mouse.newCursor(imgCursor:getData(), imgCursor:getWidth()/2, imgCursor:getHeight()/2)
   love.mouse.setCursor(Cursor)

   -- Drawing canvases
   EntityCanvas = Canvas.new(AQ.CanvasWidth, AQ.CanvasHeight)
   GUICanvas = Canvas.new(AQ.GUICanvasWidth, AQ.GUICanvasHeight)

   -- Player object loading from definition file
   Cyan = Player.new("assets.data.player-cyan")
   Cyan.entity:SetOrigin(16,32)
   Cyan.entity:SetPosition(64, 64)

   -- Testinb buttons...
   myButton = Button.new(
      {x=20, y=20, w=600, h=500},
      function() print("hello!") end,
      function() print("hovering...") end
   )
end

-- Main input key-pressed
function love.keypressed(key, scancode, isrepeat)
   -- Debug commands
   if Debug then
      if key == "f1" then
	 Debug.DrawInfo = not Debug.DrawInfo
      end

      if key == "f2" then
	 Debug.DrawHelpers = not Debug.DrawHelpers
      end

      if key == "f3" then
	 Debug.DrawGUI = not Debug.DrawGUI
      end
   end

   -- Pause
   if key == 'p' or key == 'tab' then
      gPaused = not gPaused;
   end

   -- F11 toggles fullscreen mode
   if key == 'f11' then
      love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
   end

   -- Check for leave
   if key == "escape" then
      local buttons = {"Yep!", "No!", escapebutton = 2}
      local quit = love.window.showMessageBox("Confirmation",
					      "Are you sure you want to exit?",
					      buttons);
      if (quit == 1) then love.event.push('quit'); end
   end

   -- Player keypress events
   Cyan:KeyPressed(key, scancode, isrepeat, Debug)
end

-- Main joystick button press
function love.joystickpressed(joystick, button)
   -- Pause on select button pressed
   if button == 7 then
      gPaused = not gPaused
   end
end

-- Main Update
function love.update(dt)
   next_time = next_time + min_dt

   -- Update frame buffer based on current window state
   EntityCanvas:UpdateSize(AQ.CanvasWidth, AQ.CanvasHeight)
   GUICanvas:UpdateSize(AQ.GUICanvasWidth, AQ.GUICanvasHeight)

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
   EntityCanvas:Set()
   Camera.set()
   love.graphics.clear(50, 100, 75)

   -- Draw map
   local cyanpos = Camera.position
   map.sti:setDrawRange(-cyanpos.x, -cyanpos.y, love.graphics.getWidth(), love.graphics.getHeight())
   map:draw()

   -- Draw Cyan
   Cyan:Draw()

   -- Draw debug
   if Debug and Debug.DrawHelpers then
	  love.graphics.setFont(fntPixel)
	  Cyan:DrawDebug()
   end

   Camera.unset()

   -- Draw ui (just proof of concept, doesn't actually do anything)
   if Debug and Debug.DrawGUI then
	  GUICanvas:Set()
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
   end

   -- Reset canvas
   love.graphics.setCanvas()

   -- Draw the entity canvas
   EntityCanvas:Draw()

   -- Draw GUI buffer
   if Debug.DrawGUI then
	  love.graphics.setBlendMode("alpha", "premultiplied")
	  GUICanvas:Draw()
	  love.graphics.setBlendMode("alpha")
   end

   -- Pause screen
   if gPaused then
	  love.graphics.setColor(0, 0, 0, 155)
	  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	  love.graphics.setColor(255,255,255,255)
   end

   -- Debug info
   if Debug and Debug.DrawInfo then
	  local stats = love.graphics.getStats()
	  love.graphics.setColor(255, 0, 0, 100)
	  love.graphics.rectangle("fill", 5, love.graphics.getHeight()-110, 180, 135)
	  love.graphics.setColor(255, 255, 255)
	  love.graphics.print(string.format("LOVE Ver: %d.%d.%d - %s",love.getVersion()), 10, love.graphics.getHeight()-35)
	  love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, love.graphics.getHeight()-20)
	  love.graphics.print(string.format("Draw Calls: %d\nCanvas Switches: %d\nTexture Mem: %.2f MB\nImages: %d\nCanvases: %d\nFonts: %d",
					stats.drawcalls,
					stats.canvasswitches,
					stats.texturememory/1024/1024,
					stats.images,
					stats.canvases,
					stats.fonts), 10, love.graphics.getHeight()-100)
	  love.graphics.rectangle("line",
				  EntityCanvas.offset,
				  0,
				  EntityCanvas.buffer:getWidth()*EntityCanvas.scale,
				  EntityCanvas.buffer:getHeight()*EntityCanvas.scale)
   end

   -- Manual framerate control
   local cur_time = love.timer.getTime()
   if next_time <= cur_time then
	  next_time = cur_time
	  return
   end
   love.timer.sleep(next_time - cur_time)
end
