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

   self.controls = {
      moveUp   = 'w',
      moveDown = 's',
      moveLeft = 'a',
      moveRight= 'd'
   }
   
   self.entity = Entity.new(self.data.name)
   
   self.sprite = Sprite.new(self.data.sprite)
   self.states = self.data.states
   
   self.shot   = self.data.shot
   self.direction = Vec2.new(0, 1)
   self.shooting = false
   
   return setmetatable(self, Player)
end

-- Sets the player controls to the given keys
function Player:SetControls(moveUp, moveDown, moveLeft, moveRight)
   self.controls.moveUp   = moveUp
   self.controls.moveDown = moveDown
   self.controls.moveLeft = moveLeft
   self.controls.moveRight= moveRight
end

-- Sets the movement vector based on the given vector (input axes)
function Player:SetMove(v)
   -- If the axes are 0, introduce a stopping force (opposite velocity)
   if v.x == 0 and v.y == 0 then
      v = Vec2.threshold(Vec2.scale(self.entity:GetVelocity(), -1), 1)
   end

   -- Set the acceleration from the axes
   local motion = Vec2.scale(Vec2.normalized(v), self.accel)
   self.entity:SetAcceleration(motion.x, motion.y)

   -- Ensure velocity never crosses speed
   local trimmedVel = Vec2.trim(self.entity:GetVelocity(), self.speed)
   self.entity:SetVelocity(trimmedVel.x, trimmedVel.y)
end

-- Sets the sprite state, based on the given vector (input axes)
function Player:SetSpriteState(v)
   if v.x > 0 or v.y > 0 then
      self.sprite:SetAnimation(self.states.move_right)
   elseif v.x < 0 or v.y < 0 then
      self.sprite:SetAnimation(self.states.move_left)
   else
      self.sprite:SetAnimation(self.states.idle)
   end
end

-- Player key press event (On Key Down)
function Player:KeyPressed(key, scancode, isrepeat)

end

-- Player update event
function Player:Update(dt)
   -- Gather motion axes
   if love.keyboard.isDown(self.controls.moveUp) then Player.Axes.y = -1
   elseif love.keyboard.isDown(self.controls.moveDown) then Player.Axes.y =  1 end
   if love.keyboard.isDown(self.controls.moveLeft) then Player.Axes.x = -1
   elseif love.keyboard.isDown(self.controls.moveRight) then Player.Axes.x =  1 end
   
   self:SetMove(Player.Axes)
   self:SetSpriteState(Player.Axes)
   
   self.entity:Update(dt)
   self.sprite:Update(dt)
   
   Player.Axes = Vec2.new()
end

-- Player draw event
function Player:Draw()
   self.sprite:Draw(self.entity.transform)
end

-- Player debug draw event
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
   PrintWrapped(wp.x-16, wp.y, 15, {self.name,
				    "P:"..Vec2.toString(self.entity:GetPosition()),
				    "V:"..Vec2.toString(self.entity:GetVelocity())})
   love.graphics.setColor(255,255,255)
end

return Player
