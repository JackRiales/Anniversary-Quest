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

require 'base.util'
require 'base.bounds'
local Vec2   = require 'base.vector'
local Entity = require 'base.entity'
local Sprite = require 'base.sprite'

Player = {}
Player.__index = Player
Player.Bank = {}

-- Loads a player definition file
function Player.load(def)
   if not def then return nil end

   -- Run definition
   local p = require(def)
   if not p then
      print("Definition file "..def.." returned nil.")
      return nil
   end
   Player.Bank[def] = p
   return Player.Bank[def]
end

-- Creates a new player instance
function Player.new(def)
   if not def then return nil end

   if not Player.Bank[def] then
      if not Player.load(def) then return nil end
   end

   local self = {}
   self.data   = Player.Bank[def]

   self.name   = self.data.name
   self.color  = self.data.color
   self.speed  = self.data.speed
   self.accel  = self.data.accel
   
   self.entity = Entity.new(self.data.name)
   
   self.sprite = Sprite.new(self.data.sprite)
   self.states = self.data.states
   
   self.shot   = self.data.shot
   self.direction = Vec2.new(0, 1)
   self.shooting = false
   
   return setmetatable(self, Player)
end

function Player:SetMove(v)
   --self.entity:SetAcceleration(Vec2.scale(v, self.accel))
end

function Player:Update(dt)
   -- Gather motion axes
   local axes = Vec2.new()
   if love.keyboard.isDown("w") then axes.y = -1
   elseif love.keyboard.isDown("s") then axes.y = 1 end
   if love.keyboard.isDown("a") then axes.x = -1
   elseif love.keyboard.isDown("d") then axes.x = 1 end
   self:SetMove(axes)
   
   self.entity:Update(dt)
   self.sprite:Update(dt)
end

function Player:Draw()
   self.sprite:Draw(self.entity.transform)
end

return Player
