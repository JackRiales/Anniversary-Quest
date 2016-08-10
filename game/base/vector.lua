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

local Vec2 = {}
Vec2.__index = Vec2

function Vec2.new(x, y)
   return {x=x or 0, y=y or 0}
end

function Vec2.verify(v)
   return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
end

function Vec2.toString(v)
   return string.format("(%.2f, %.2f)", v.x, v.y)
end

function Vec2.dist(v1, v2)
   assert(Vec2.verify(v1) and Vec2.verify(v2), "Vec2.dist - Wrong argument types")
   local dx = v1.x - v2.x
   local dy = v1.y - v2.y
   return math.sqrt(dx*dx + dy*dy)
end

function Vec2.dist2(v1, v2)
   assert(Vec2.verify(v1) and Vec2.verify(v2), "Vec2.dist2 - Wrong argument types")
   local dx = v1.x - v2.x
   local dy = v1.y - v2.y
   return dx*dx + dy*dy
end

function Vec2.magnitude(v)
   assert(Vec2.verify(v), "Vec2.magnitude - Wrong argument types")
   return math.sqrt(v.x*v.x + v.y*v.y)
end

function Vec2.magnitude2(v)
   assert(Vec2.verify(v), "Vec2.magnitude2 - Wrong argument types")
   return v.x*v.x + v.y*v.y
end

function Vec2.normalized(v)
   assert(Vec2.verify(v), "Vec2.normalized - Wrong argument types")
   local len = Vec2.magnitude(v)
   if len > 0 then
      return Vec2.new(v.x/len, v.y/len)
   else
      return Vec2.new()
   end
end

function Vec2.floor(v)
   assert(Vec2.verify(v), "Vec2.floor - Wrong argument types")
   return Vec2.new(math.floor(v.x), math.floor(v.y))
end

function Vec2.trim(v, len)
   assert(Vec2.verify(v), "Vec2.trim - Wrong argument types")
   local s = len*len / Vec2.magnitude2(v)
   s = (s > 1 and 1) or math.sqrt(s)
   return Vec2.new(v.x * s, v.y * s)
end

function Vec2.threshold(v, min)
   assert(Vec2.verify(v), "Vec2.threshold - Wrong argument types")
   local len = Vec2.magnitude(v)
   if len < min then
      return Vec2.new()
   else
      return v
   end
end

function Vec2.angle(v1, v2)
   assert(Vec2.verify(v1) and Vec2.verify(v2), "Vec2.angle - Wrong argument types")
   return math.atan2(v1.y, v1.x) - math.atan2(v2.y, v2.x)
end

function Vec2.add(v1, v2)
   assert(Vec2.verify(v1) and Vec2.verify(v2), "Vec2.add - Wrong argument types")
   return Vec2.new(v1.x+v2.x, v1.y+v2.y)
end

function Vec2.sub(v1, v2)
   assert(Vec2.verify(v1) and Vec2.verify(v2), "Vec2.sub - Wrong argument types")
   return Vec2.new(v1.x-v2.x, v1.y-v2.y)
end

function Vec2.scale(v, s)
   assert(Vec2.verify(v) and type(s) == 'number', "Vec2.scale - Wrong argument types")
   return Vec2.new(v.x*s, v.y*s)
end

function Vec2.cross(v1, v2)
   assert(Vec2.verify(v1) and Vec2.verify(v2), "Vec2.sub - Wrong argument types")
   return v1.x * v2.y - v1.y * v2.x
end

return Vec2
