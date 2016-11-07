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

local Vec2 = require 'engine.math.vector'

local Entity = {}
Entity.__index = Entity

-- Creates and returns a new instance
function Entity.new(name)
   local self = {}
   self.name = name or "New Entity"
   self.transform = {}
   self.transform.angle    = 0
   self.transform.position = Vec2.new()
   self.transform.velocity = Vec2.new()
   self.transform.accel    = Vec2.new()
   self.transform.scale    = Vec2.new(1,1)
   self.transform.origin   = Vec2.new()
   
   self.flUpdate = true -- Is this allowed to update?

   return setmetatable(self, Entity)
end

-- Updates an entity, in a generic sense, and then
-- calls the given update function
function Entity:Update(dt)
   if not self.flUpdate then return end
   self.transform.velocity = Vec2.round(Vec2.add(self.transform.velocity,
						 Vec2.scale(self.transform.accel, dt)))
   self.transform.position = Vec2.round(Vec2.add(self.transform.position,
						 Vec2.scale(self.transform.velocity, dt)))
end

-- TODO(Jack): This is ... awful. Remove this and format the system better
function Entity:GetTransform() return self.transform end
function Entity:GetPosition()  return self.transform.position end
function Entity:GetVelocity()  return self.transform.velocity end
function Entity:GetAcceleration() return self.transform.accel end
function Entity:GetRotation() return self.transform.angle end
function Entity:GetScale()    return self.transform.scale end
function Entity:GetOrigin()   return self.transform.origin end

function Entity:SetTransform(t) self.transform = t end
function Entity:SetPosition(x,y) self.transform.position = Vec2.new(x,y) end
function Entity:SetVelocity(dx,dy) self.transform.velocity = Vec2.new(dx,dy) end
function Entity:SetAcceleration(ddx,ddy) self.transform.accel = Vec2.new(ddx,ddy) end
function Entity:SetScale(sx,sy) self.transform.scale = Vec2.new(sx,sy) end
function Entity:SetOrigin(ox,oy) self.transform.origin = Vec2.new(ox,oy) end
function Entity:SetRotation(a) self.transform.angle = a end

return Entity
