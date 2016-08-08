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

-- Global entity table
Ent_ITable = {}
Ent_UIDDispatch = 0

function Entity.new(name)
   local self = {}
   self.name = name or "New Entity"
   self.transform = {}
   self.transform.angle    = 0
   self.transform.position = { x = 0, y = 0 }
   self.transform.scale    = { x = 1, y = 1 }
   self.transform.origin   = { x = 0, y = 0 }
   self.transform.shear    = { x = 0, y = 0 }

   self.graphics = {}
   self.graphics.source    = { x = 0, y = 0, w = 0, h = 0 }
   self.graphics.size      = { w = 32, h = 32 }
   
   self.flUpdate = true -- Is this allowed to update?
   self.flDraw   = true -- Is this allowed to draw?

   -- Add to the entity table
   Ent_ITable[Ent_UIDDispatch] = self
   Ent_UIDDispatch = Ent_UIDDispatch + 1

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

-- Draw the entity using a graphic (Drawable) to a given target
function Entity:Draw(graphic, target)
   if not self.flDraw then return end
   love.graphics.setCanvas(target)
   love.graphics.draw(graphic,
		      self.transform.position.x,
		      self.transform.position.y,
		      self.transform.angle*(180/3.14),
		      self.transform.scale.x,
		      self.transform.scale.y,
		      self.transform.origin.x,
		      self.transform.origin.y,
		      self.transform.shear.x,
		      self.transform.shear.y)
   love.graphics.setCanvas(nil)
end

return Entity
