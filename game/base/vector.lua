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
Vec2.__index = vector

function Vec2.new(x, y)
   return setmetatable({x=x or 0, y=y or 0}, Vec2)
end

function Vec2.verify(v)
   return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
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

function Vec2.normalized(v)
   assert(Vec2.verify(v), "Vec2.getNormalized - Wrong argument types")
   return v:clone():normalize()
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
   assert(Vec2.verify(v) and type(s) == 'number', "Vec2.mul - Wrong argument types")
   return Vec2.new(v.x*s, v.y*s)
end

function Vec2.cross(v1, v2)
   assert(Vec2.verify(v1) and Vec2.verify(v2), "Vec2.sub - Wrong argument types")
   return v1.x * v2.y - v1.y * v2.x
end

-----------------------------------------------------------------
-- Instance functions
-----------------------------------------------------------------
function Vec2:clone()
   return Vec2.new(self.x, self.y)
end

function Vec2:__tostring()
   return "("..tonumber(self.x)..","..tonumber(self.y)..")"
end

function Vec2:magnitude()
   return math.sqrt(self.x*self.x + self.y*self.y)
end

function Vec2:magnitude2()
   return self.x*self.x + self.y*self.y
end

function Vec2:normalize()
   local len = self:len()
   if len > 0 then
      self.x, self.y = self.x / len, self.y / len
   end
   return self
end

function Vec2:angle(v2)
   assert(Vec2.verify(v2), "Vec2.angle - Wrong argument types")
   return math.atan2(self.y, self.x) - math.atan2(v2.y, v2.x)
end

function Vec2:add(v2)
   assert(Vec2.verify(v2), "Vec2.add - Wrong argument types")
   self.x, self.y = self.x+v2.x, self.y+v2.y
end

function Vec2:sub(v2)
   assert(Vec2.verify(v2), "Vec2.sub - Wrong argument types")
   self.x, self.y = self.x-v2.x, self.y-v2.y
end

function Vec2:scale(s)
   self.x, self.y = self.x * s, self.y * s
end

function Vec2:cross(v2)
   assert(Vec2.verify(v2), "Vec2.sub - Wrong argument types")
   return self.x * v2.y - self.y * v2.x
end

return Vec2
