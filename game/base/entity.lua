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

-- Global entity table
Entity_InstanceTable = {}
Entity_UIDDispatch = 0

-- Initializes a new instance of an entity
function Entity_Init(name)
   local self = {}
   self.name = name or "New Entity"
   self.transform = {}
   self.transform.angle    = 0
   self.transform.position = { x = 0, y = 0 }
   self.transform.scale    = { x = 1, y = 1 }
   self.transform.origin   = { x = 0, y = 0 }
   self.transform.shear    = { x = 0, y = 0 }

   self.size     = 0
   
   self.flUpdate = true -- Is this allowed to update?
   self.flDraw   = true -- Is this allowed to draw?

   -- Add to the entity table
   Entity_InstanceTable[Entity_UIDDispatch] = self
   Entity_UIDDispatch = Entity_UIDDispatch + 1

   return self;
end

-- Updates an entity, in a generic sense, and then
-- calls the given update function
function Entity_Update(entity, callback, dt)
   assert(entity)
   if callback then
      callback(dt)
   end
end

-- Draws an entity with the given graphic to the given target (or screen, if nil)
function Entity_Draw(entity, graphic, target)
   if entity.flDraw == false or not graphic then
      return
   end
   love.graphics.setCanvas(target)
   love.graphics.draw(graphic,
		      entity.transform.position.x,
		      entity.transform.position.y,
		      entity.transform.angle*(180/3.14),
		      entity.transform.scale.x,
		      entity.transform.scale.y,
		      entity.transform.origin.x,
		      entity.transform.origin.y,
		      entity.transform.shear.x,
		      entity.transform.shear.y)
   love.graphics.setCanvas(nil)
end
