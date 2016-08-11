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

require 'base.bounds'

local Collider = {}
Collider.__index = Collider

Collider.ITable = {}
Collider.ID = 1

function Collider.new(x, y, w, h)
   local self = {}
   self.id     = Collider.ID
   self.active = true
   self.x      = x or 0
   self.y      = y or 0
   self.w      = w or 0
   self.h      = h or 0
   local ret = setmetatable(self, Collider)
   Collider.ITable[self.id] = ret
   Collider.ID = Collider.ID + 1
   return ret
end

function Collider:SetActive(bool)
   self.active = bool
end

function Collider:Set(x, y, w, h)
   self.x      = x
   self.y      = y
   self.w      = w
   self.h      = h
end

function Collider:GetCenterPoint()
   return {
      x = self.x + (self.w / 2),
      y = self.y + (self.h / 2)
   }
end

function Collider:Check()
   if not self.active then return nil end
   local collisions = {}
   for _,value in ipairs(Collider.ITable) do
      if value ~= nil then
	 if (BoundsIntersect(self, value)) and value.active then
	    table.insert(collisions, value)
	 end
      end
   end
   return collisions
end

function Collider:Destroy()
   Collider.ITable[self.id] = nil
end

return Collider
