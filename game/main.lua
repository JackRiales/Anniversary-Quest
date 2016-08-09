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
require 'base.bounds'
local Entity = require 'base.entity'
local Sprite = require 'base.sprite'

-- Main globals
DEBUG = true
ASSET_PATH = "assets/"

function love.preload()
   -- Extra graphics settings
   love.graphics.setDefaultFilter("nearest","nearest")
end

-- Main load
function love.load()
   -- Create a room to walk around in
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
   
   -- ... and a thing to move in it
   en = Entity.new("Thing");
   en.size = 32
   en.speed = 360
   en:SetPosition({
      x = love.graphics.getWidth() / 2,
      y = love.graphics.getHeight() / 2
   })
   en:SetScale({
      x = 2, y = 2
   })
   en:SetOrigin({
      x = 16 * en.transform.scale.x, y = 32 * en.transform.scale.x
   })
   en.collider = {
      x = 0, -- local to the origin
      y = 0, -- local to the origin
      w = en.size,
      h = en.size
   }
   en.animation = Sprite.new('data.Sprite-Cyan')
   
   -- TODO(Jack): Obviously we'll want to move this to like a player class file
   function en_update(dt)
      if (love.keyboard.isDown("w")) then
	 en.transform.position.y = en.transform.position.y - dt * en.speed
      elseif (love.keyboard.isDown("s")) then
	 en.transform.position.y = en.transform.position.y + dt * en.speed
      end
      
      if (love.keyboard.isDown("a")) then
	 en.transform.position.x = en.transform.position.x - dt * en.speed
      elseif (love.keyboard.isDown("d")) then
	 en.transform.position.x = en.transform.position.x + dt * en.speed
      end

      -- Some basic room collision
      --[[en:SetPosition(NearestPoint({x = en:GetPosition().x + en:GetOrigin().x,
	 y = en:GetPosition().y + en:GetOrigin().y}, Room.bounds))--]]
      

      -- Update that sprite
      en.animation:Update(dt)
   end
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
   en:Update(en_update, dt)
end

-- Main Draw
function love.draw()
   Room.draw()
   
   -- Draw sprite
   en.animation:Draw(en.transform)
   
   -- Debug info
   if not DEBUG then return end
   love.graphics.setColor(0, 255, 0, 100)
   love.graphics.rectangle("fill", 5, 5, 220, 50)
   love.graphics.setColor(255, 255, 255)
   love.graphics.print(string.format("LOVE Ver: %d.%d.%d - %s",love.getVersion()), 10, 10)
   love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 25)
   love.graphics.print("Entity Count: "..tostring(#Ent_ITable), 10, 40)
   en:DrawDebugInfo({r = 255, g = 0, b = 78})
end
