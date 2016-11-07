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

local Entity = {}
Entity.__index = Entity

-- Static cache used to house references to 
-- component modules
Entity._ComponentCache = {}

-- Creates and returns a new instance
function Entity.new(name)
    local self = {}
   
	-- Entity name for the purpose of debug listing
	-- ... or finding, in desperate situations that
	-- ... should really never happen.
    self.name = name or "New Entity"
   
	-- Table of components (transform, etc)
	self.Components = {}
	
    return setmetatable(self, Entity)
end

-- Updates an entity, in a generic sense, and then
-- calls the given update function
function Entity:Update(dt)
	for k, v in pairs(self.Components) do
		if v.Active then
			v:Update(self, dt)
		end
	end
end

-- Adds a component to this entity
function Entity:AddComponent(c)
	if not Entity._ComponentCache[c] then
		cdef = require(c)
		Entity._ComponentCache[c] = cdef
	end
	self.Components[c] = Entity._ComponentCache[c]
	return self.Components[c]
end

-- Removes the component from the entity
function Entity:RemoveComponent(c)
	self.Components[c] = nil
end

return Entity
