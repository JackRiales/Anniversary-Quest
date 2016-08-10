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
Player.Axes = Vec2.new()

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
   local motion = Vec2.scale(Vec2.normalized(v), self.speed)
   self.entity:SetVelocity(motion.x, motion.y)
end

function Player:Update(dt)
   -- Gather motion axes
   if love.keyboard.isDown("w")     then Player.Axes.y = -1
   elseif love.keyboard.isDown("s") then Player.Axes.y =  1 end
   if love.keyboard.isDown("a")     then Player.Axes.x = -1
   elseif love.keyboard.isDown("d") then Player.Axes.x =  1 end
   
   self:SetMove(Player.Axes)
   self.entity:Update(dt)
   self.sprite:Update(dt)
   Player.Axes = Vec2.new()
end

function Player:Draw()
   self.sprite:Draw(self.entity.transform)
end

function Player:DrawDebug(color)
   if color then
      love.graphics.setColor(color.r, color.g, color.b)
   else
      love.graphics.setColor(self.color.r, self.color.g, self.color.b)
   end
   local wp = self.entity:GetWorldPosition()
   -- Draw the origin point
   love.graphics.circle("fill", wp.x, wp.y, 3, 5)

   -- Print debug info
   PrintWrapped(wp.x, wp.y, 15, {self.name,
				 Vec2.toString(self.entity:GetPosition()),
				 Vec2.toString(self.entity:GetVelocity())})
   love.graphics.setColor(255,255,255)
end

return Player
