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

local sti = require 'lib.sti'

Map = {}
Map.__index = Map
Map.Bank = {}

local function Map.load(path)
   if not path then return nil end
   Map.Bank[path] = sti(path)
   return true
end

function Map.new(map, itemMap, enemyMap, player)
   if not map then return nil end
   if not Map.Bank[map] then
      if not Map.load(map) then
	 print("Map.new - Map could not be loaded")
	 return nil
      end
   end

   local self = {}
   self.sti = Map.Bank[map]
   self.itemMap = itemMap
   self.enemyMap = enemyMap
   self.player = player
   return setmetatable(self, Map)
end

function Map:update(dt)
   self.sti:update(dt)
end

function Map:draw()
   self.sti:draw()
end

return Map
