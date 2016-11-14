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

local Vec2 = require 'engine.math.vector'

local Transform = {}
Transform.__index = Transform

function Transform.new(position, rotation, scale)
  local o = {}
  o._type    = "Transform"            -- Type validator
  o.Position = position or Vec2.new() -- World position
  o.Rotation = rotation or 0          -- Rotation angle (in degrees; casted to rad during draw)
  o.Scale    = scale    or 0          -- Scale factor (uniform)
  o.Parent   = nil                    -- Parent transform
  o.Children = {}                     -- Child transforms
  return setmetatable(o, Transform)
end

function Transform:SetParent(parent, castPosition)
  assert(parent._type == "Transform", "Transform:SetParent -- Wrong argument type")
  self.Parent = parent
  if (castPosition or false) then
    -- TODO(Jack): Cast the position to the new parent
    --             I.e., if this object was at (5, 10) and becomes a child
    --             of something at (3, 2), make sure it stays at the real
    --             world point of (5, 10), relative to the new parent
  end
end

function Transform:Translate(deltaPosition)
  self.Position = Vec2.add(self.Position, deltaPosition)
  if #self.Children > 0 then
    for i=0, #self.Children do
      self.Children[i]:Translate(deltaPosition)
    end
  end
end

function Transform:Rotate(deltaRotation)
  self.Rotation = self.Rotation + deltaRotation
  if #self.Children > 0 then
    for i=0, #self.Children do
      self.Children[i]:Rotate(deltaRotation)
    end
  end
end

function Transform:Scale(deltaScale)
  self.Scale = self.Scale + deltaScale
  if #self.Children > 0 then
    for i=0, #self.Children do
      self.Children[i]:Scale(deltaScale)
    end
  end
end

return Transform
