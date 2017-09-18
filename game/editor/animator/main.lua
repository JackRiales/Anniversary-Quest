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

LicenseText = [[Copyright (c) 2016 Jack Riales. All Rights Reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.]]

require "lib.catui"

GoodFileExtensions = {".png", ".jpg", ".bmp"}

function CheckFileExtension(st, extensions)
	for i,v in ipairs(extensions) do
		if string.find(st, v) then return true end
	end
	return false
end

function LoadImageFile(filename)
	if CheckFileExtension(filename, GoodFileExtensions) then

	end 
end

function Entity()
end

-- [[[[[[[[[[[[[[[[[ Main Love2D Functions ]]]]]]]]]]]]]]]]]]] --
function love.load(arg)
	LoadedSprite = nil
end

function love.filedropped(file)
	LoadedSprite = LoadImageFile(file:getFilename())
end

function love.update(dt)

end

function love.draw()

	-- Draw sprite

	-- Draw controls

end