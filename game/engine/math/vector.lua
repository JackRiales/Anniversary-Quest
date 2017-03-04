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
   return setmetatable({x=x or 0, y=y or 0}, Vec2)
end

function Vec2.__call(this, x, y)
   return Vec2.new(x, y)
end

function Vec2.__tostring(v)
   return string.format("(%.2f, %.2f)", v.x, v.y)
end

function Vec2.__eq(v1, v2)
   return v1.x == v2.x and v1.y == v2.y
end

function Vec2.__add(v1, v2)
   return Vec2(v1.x + v2.x, v1.y + v2.y)
end

function Vec2.__sub(v1, v2)
   return Vec2(v1.x - v2.x, v1.y - v2.y)
end

function Vec2.verify(v)
   return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
end

function Vec2:dist2(v)
   assert(Vec2.verify(v), 'Vec2 distance - Wrong argument type')
   local dx = v1.x - v2.x
   local dy = v1.y - v2.y
   return dx*dx + dy*dy
end

function Vec2:dist(v)
   assert(Vec2.verify(v), 'Vec2 distance - Wrong argument type')
   return math.sqrt(self:dist2(v))
end

function Vec2:mag2(v)
   return self.x * self.x + self.y * self.y
end

function Vec2:mag()
   return math.sqrt(self:mag2())
end

function Vec2:normalized()
   local len = self:mag()
   if len > 0 then
      return Vec2(self.x/len, self.y/len)
   else
      return Vec2()
   end
end

function Vec2:floor()
   return Vec2(math.floor(self.x), math.floor(self.y))
end

function Vec2:round()
   return Vec2(math.floor(self.x+0.5), math.floor(self.y+0.5))
end

function Vec2:trim(len)
   local s = len*len / self:mag2()
   s = (s > 1 and 1) or math.sqrt(s)
   return Vec2(self.x * s, self.y * s)
end

function Vec2:threshold(min)
   local len = self:mag(v)
   if len < min then
      return Vec2()
   else
      return self
   end
end

function Vec2:angle(v)
   assert(Vec2.verify(v), "Vec2.angle - Wrong argument types")
   return math.atan2(self.y, self.x) - math.atan2(v.y, v.x)
end

function Vec2:scale(s)
   assert(type(s) == 'number', "Vec2.scale - Wrong argument types")
   return Vec2(self.x*s, self.y*s)
end

function Vec2:cross(v)
   assert(Vec2.verify(v2), "Vec2.sub - Wrong argument types")
   return self.x * v.y - self.y * v.x
end

return Vec2
