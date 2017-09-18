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

local Enemy = {}
Enemy.__index = Enemy
Enemy.Bank = {}

function Enemy.load(def)
	if not def then return nil end

	local e = require(def)
	if not e then 
		print("Definition file "..def.." returned nil.")
    	return nil
    end

    Enemy.Bank[def] = e
end

function Enemy.new(def)
	if not def then return nil end

	if not Enemy.Bank[def] then
		if not Enemy.load(def) then return nil end
	end

    local o = {
        health = def.hp or 0
    }

    return setmetatable(o, Enemy)
end

function Enemy.__call(def)
	return Enemy.new(def)
end

return Enemy
