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

-- Entity.lua
-- Defines a generic entity, that reacts to "physics" and
-- can be interacted with (ideally).

local Entity = {}
Entity.__index = Entity

-- Creates and returns a new instance
function Entity.new(name)
   local self = {}
   self.name = name or "New Entity"
   self.transform = {}
   self.transform.angle    = 0
   self.transform.position = { x = 0, y = 0 }
   self.transform.scale    = { x = 1, y = 1 }
   self.transform.origin   = { x = 0, y = 0 }
   self.transform.shear    = { x = 1, y = 1 }
   
   self.flUpdate = true -- Is this allowed to update?

   return setmetatable(self, Entity)
end

-- Updates an entity, in a generic sense, and then
-- calls the given update function
function Entity:Update(callback, dt)
   if not self.flUpdate then return end
   -- Do some generic important stuff here
   if callback then
      callback(dt)
   end
end

function Entity:DrawDebugInfo(color)
   if color then
      love.graphics.setColor(color.r, color.g, color.b)
   end
   love.graphics.print(self.name,
		       self.transform.position.x,
		       self.transform.position.y-15)
   love.graphics.print("P:("..
			  string.format("%.1f",self.transform.position.x)..","..
			  string.format("%.1f",self.transform.position.y)..")",
		       self.transform.position.x,
		       self.transform.position.y)
   love.graphics.circle("fill",
			self.transform.position.x + self.transform.origin.x,
			self.transform.position.y + self.transform.origin.y,
			6, 8)
   love.graphics.setColor(255,255,255);
end

--[[
   Accessors and Mutators, for convenience
--]]
function Entity:GetTransform() return self.transform end
function Entity:GetPosition() return self.transform.position end
function Entity:GetRotation() return self.transform.angle end
function Entity:GetScale()    return self.transform.scale end
function Entity:GetOrigin()   return self.transform.origin end
function Entity:GetShear()    return self.transform.shear end

function Entity:SetTransform(t) self.transform = t end
function Entity:SetPosition(p) self.transform.position = p end
function Entity:SetRotation(a) self.transform.angle = a end
function Entity:SetScale(s) self.transform.scale = s end
function Entity:SetOrigin(o) self.transform.origin = o end
function Entity:SetShear(s) self.transform.shear = s end

return Entity
