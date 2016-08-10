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
local Player = require 'player'

-- Main globals
DEBUG = true

-- Main load
function love.load()
   -- Extra graphics settings
   love.graphics.setDefaultFilter("nearest","nearest")
   
   -- Create a room to walk around in (Prototype)
   Room = {};
   Room.marginW = 95
   Room.marginH = 10
   Room.color = {
      r = 95,
      g = 87,
      b = 79
   }
   Room.bounds = {
      x = Room.marginW,
      y = Room.marginH,
      w = love.graphics.getWidth()-Room.marginW*2,
      h = love.graphics.getHeight()-Room.marginH*2,      
   }
   Room.draw = function()
      love.graphics.setColor(Room.color.r, Room.color.g, Room.color.b)
      love.graphics.rectangle("fill",
			      Room.bounds.x,
			      Room.bounds.y,
			      Room.bounds.w,
			      Room.bounds.h)
      love.graphics.setColor(255,255,255);
   end

   -- Drawing canvas
   BackBuffer = love.graphics.newCanvas(256,256)
   Scale_BackBuffer = love.graphics.getHeight()/BackBuffer:getHeight()
   
   -- Player object loading from definition file
   Cyan = Player.new("data.Player-Cyan")
   Cyan.entity:SetOrigin(16,32)
   Cyan.entity:SetPosition(64, 64)
end

-- Main input key-pressed
function love.keypressed(key, scancode, isrepeat)
   -- Check for toggle debug
   if key == "`" then
      if DEBUG then DEBUG = false
      else DEBUG = true end
   end
   
   -- Check for leave
   if key == "escape" then
      local buttons = {"NO!", "Yep!", escapebutton = 1}
      local quit = love.window.showMessageBox("Confirmation",
					      "Are you sure you want to exit?",
					      buttons);
      if (quit == 2) then love.event.push('quit'); end
   end
end

-- Main Update
function love.update(dt)
   Cyan:Update(dt)
end

-- Main Draw
function love.draw()
   Room.draw()
   love.graphics.setCanvas(BackBuffer)
   love.graphics.clear()
   Cyan:Draw()
   love.graphics.setCanvas()

   love.graphics.rectangle("line",
			   love.graphics.getWidth()/2-(BackBuffer:getWidth()*Scale_BackBuffer)/2, 0,
			   BackBuffer:getWidth()*Scale_BackBuffer,
			   BackBuffer:getHeight()*Scale_BackBuffer)
   love.graphics.draw(BackBuffer,
		      love.graphics.getWidth()/2-(BackBuffer:getWidth()*Scale_BackBuffer)/2,
		      0,
		      0,
		      Scale_BackBuffer,
		      Scale_BackBuffer,
		      0,
		      0)
   
   -- Debug info
   if not DEBUG then return end
   love.graphics.setColor(0, 255, 0, 100)
   love.graphics.rectangle("fill", 5, 5, 220, 50)
   love.graphics.setColor(255, 255, 255)
   love.graphics.print(string.format("LOVE Ver: %d.%d.%d - %s",love.getVersion()), 10, 10)
   love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 25)
   Cyan:DrawDebug()
end
