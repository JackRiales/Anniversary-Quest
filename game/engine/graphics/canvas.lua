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

local Canvas = {}
Canvas.__index = Canvas

function Canvas.new(width, height)
   local self = {}
   self.width = width;
   self.height = height;
   self.buffer = love.graphics.newCanvas(width, height)
   self.scale = love.graphics.getHeight() / height
   self.offset = love.graphics.getWidth() / 2 - (width * self.scale) / 2
   return setmetatable(self, Canvas)
end

function Canvas:UpdateSize(width, height)
   self.width = width;
   self.height = height;
   self.scale = love.graphics.getHeight() / height
   self.offset = love.graphics.getWidth() / 2 - (width * self.scale) / 2
end

function Canvas:Set()
   love.graphics.setCanvas(self.buffer)
end

function Canvas:Draw()
   love.graphics.draw(self.buffer,
		                self.offset,
		                0,
		                0,
		                self.scale,
		                self.scale)
end

return Canvas;
