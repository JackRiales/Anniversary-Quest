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

local Vec2 = require 'base.vector'

local Camera = {}
Camera.position = Vec2.new()
Camera.scale    = Vec2.new(1, 1)
Camera.rotation = 0

function Camera.set()
   love.graphics.push()
   love.graphics.rotate(-Camera.rotation)
   love.graphics.scale(1/Camera.scale.x, 1/Camera.scale.y)
   love.graphics.translate(-Camera.position.x, -Camera.position.y)
end

function Camera.unset()
   love.graphics.pop()
end

function Camera.move(dx, dy)
   Camera.position.x = Camera.position.x + (dx or 0)
   Camera.position.y = Camera.position.y + (dy or 0)
end

function Camera.rotate(dr)
   Camera.rotation = Camera.rotation + dr
end

function Camera.moveScale(sx, sy)
   sx = sx or 1
   Camera.scale.x = Camera.scale.x * sx
   Camera.scale.y = Camera.scale.y * (sy or sx)
end

function Camera.setPosition(x, y)
   Camera.position = Vec2.new(x, y)
end

function Camera.setRotation(theta)
   Camera.rotation = theta
end

function Camera.setScale(x, y)
   Camera.scale = Vec2.new(x or 1, y or 1)
end

return Camera
