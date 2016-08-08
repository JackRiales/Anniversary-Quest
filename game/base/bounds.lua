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

-- Bounding box point intersection
-- Returns true if the given point is inside the bounding box
function PointIntersectsBounds(p, b)
   return
      b.x <= p.x and
      p.x <= b.w and
      b.y <= p.y and
      p.y <= b.h
end

-- Same function, verbose
function PointIntersectsBoundsVerbose(x, y, bx, by, bw, bh)
   return
      bx <= x  and
      x  <= bw and
      by <= y  and
      y  <= bh
end

-- Bounding box intersection function
-- Returns true if the two rects overlap
-- x and y are the top left coords of each rect,
-- and w and h are obviously width and height.
function BoundsIntersect(b1, b2)
   return
      b1.x < b2.x + b2.w and
      b2.x < b1.x + b1.w and
      b1.y < b2.y + b2.h and
      b2.y < b1.y + b1.h
end

-- Same function, verbose version
function BoundsIntersectVerbose(x1, y1, w1, h1,
			 x2, y2, w2, h2)
   return
      x1 < x2 + w2 and
      x2 < x1 + w1 and
      y1 < y2 + h2 and
      y2 < y1 + h1
end

-- Bounding box nearest point function
-- Returns the nearest point on a bounding box to a given point
-- If the point is inside the box, returns the point
function NearestPoint(p, b)
   if (PointIntersectsBounds(p, b)) then
      return p
   end

   -- Copy p
   local n = { x = p.x, y = p.y }

   -- Clamp it by b
   if n.x < b.x then
      n.x = b.x
   elseif n.x > b.w then
      n.x = b.w
   end
   if n.y < b.y then
      n.y = b.y
   elseif n.y > b.h then
      n.y = b.h
   end
   return n
end
