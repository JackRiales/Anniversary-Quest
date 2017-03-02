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

local Bounds = {}
Bounds.__index = Bounds

function Bounds.new(x, y, w, h)
   return setmetatable({x=x, y=y, w=w, h=h}, Bounds)
end

-- Bounding box point intersection
-- Returns true if the given point is inside the bounding box
function Bounds:CheckPoint(point)
   return 
      self.x  <= point.x and
      point.x <= self.w  and
      self.y  <= point.y and
      point.y <= self.h
end

-- Bounding box intersection function
-- Returns true if the two rects overlap
-- x and y are the top left coords of each rect,
-- and w and h are obviously width and height.
function Bounds:Intersects(b2)
   return
      self.x < b2.x   + b2.w   and
      b2.x   < self.x + self.w and
      self.y < b2.y   + b2.h   and
      b2.y   < self.y + self.h
end

-- Bounding box nearest point function
-- Returns the nearest point on a bounding box to a given point
-- If the point is inside the box, returns the point
function Bounds:NearestPoint(p)
   if (self:CheckPoint(p)) then
      return p
   end

   -- Copy p
   local n = { x = p.x, y = p.y }

   -- Clamp it by b
   if n.x < self.x then
      n.x = self.x
   elseif n.x > self.w then
      n.x = self.w
   end
   if n.y < self.y then
      n.y = self.y
   elseif n.y > self.h then
      n.y = self.h
   end
   return n
end

return Bounds