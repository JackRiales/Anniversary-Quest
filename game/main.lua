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

-- Cyan's Adventure to Save the Things 2
-- by Jack Riales
--
-- P.S. If you find yourself reading this, I love you! Happy 9th.
-- I'm actually writing this on August 7th. Pretty crazy right?
-- Anyway, I hope you enjoy.

-- Dependencies
require 'base.bounds'
local Entity = require 'base.entity'

-- Some globals
ASSET_PATH = "assets/"
print(love.filesystem.getWorkingDirectory())

-- Main load
function love.load()
   -- Prototyping!

   -- TODO(Jack): Find a way to load these out from a data file (tiled?)
   
   -- Create a room to walk around in
   Room = {};
   Room.marginW = 75
   Room.marginH = 35
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
   end
   
   -- ... and a thing to move in it
   en = Entity.new("Thing");
   en.size = 32
   en.speed = 80
   en.transform.position = {
      x = love.graphics.getWidth() / 2,
      y = love.graphics.getHeight() / 2
   }
   en.collider = {
      x = 0, -- local to the origin
      y = 0, -- local to the origin
      w = en.size,
      h = en.size
   }
   en.image = love.graphics.newImage(ASSET_PATH .. "spr/SprCyan.png");

   function en_update(dt)
      if (love.keyboard.isDown("w")) then
	 en.transform.y = en.transform.position.y - dt * en.speed
      elseif (love.keyboard.isDown("s")) then
	 en.transform.y = en.transform.position.y + dt * en.speed
      end
      
      if (love.keyboard.isDown("a")) then
	 en.transform.x = en.transform.position.x - dt * en.speed
      elseif (love.keyboard.isDown("d")) then
	 en.transform.x = en.transform.position.x + dt * en.speed
      end

      -- Some basic room collision
      en.transform.position = NearestPoint(en.transform.position, Room.bounds)
   end
end

-- Main Update
function love.update(dt)
   en:Update(en_update, dt)

   -- Check for leave
   if (love.keyboard.isDown("escape")) then
      local buttons = {"NO!", "Yep!", escapebutton = 1}
      local quit = love.window.showMessageBox("Confirmation",
					      "Are you sure you want to exit?",
					      buttons);
      if (quit == 2) then
	 love.event.push('quit');
      end
   end
end

-- Main Draw
function love.draw()
   Room.draw()
   en:Draw(en.image, nil)
end
