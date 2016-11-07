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

require 'engine.math.bounds'

local Vec2   = require 'engine.math.vector'
local Entity = require 'engine.ecs.entity'
local Sprite = require 'engine.graphics.sprite'

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

   self.controls = {}
   self.controls.keys = {
      moveUp   = 'w',
      moveDown = 's',
      moveLeft = 'a',
      moveRight= 'd',
      shootUp   = 'up',
      shootDown = 'down',
      shootLeft = 'left',
      shootRight= 'right',
   }
   self.controls.joystick = {
      moveUp   = "u", -- hat up
      moveDown = "d", -- hat down
      moveLeft = "l", -- hat left
      moveRight= "r"  -- hat right
   }
   self.controls.jid  = 1 -- joystick id
   
   self.entity = Entity.new(self.data.name)
   
   self.sprite = Sprite.new(self.data.sprite)
   self.states = self.data.states

   return setmetatable(self, Player)
end

function Player:SetKeyboardControls(controls)
   self.controls.keys.moveUp   = controls.moveUp   or "w"
   self.controls.keys.moveDown = controls.moveDown or "s"
   self.controls.keys.moveLeft = controls.moveLeft or "a"
   self.controls.keys.moveRight= controls.moveRight or "d"
end

function Player:GetMotionInput()
   -- Check keyboard input
   if     love.keyboard.isDown(self.controls.keys.moveUp)    then Player.Axes.y = -1
   elseif love.keyboard.isDown(self.controls.keys.moveDown)  then Player.Axes.y =  1 end
   if     love.keyboard.isDown(self.controls.keys.moveLeft)  then Player.Axes.x = -1
   elseif love.keyboard.isDown(self.controls.keys.moveRight) then Player.Axes.x =  1 end

   -- Check joystick axes
   if love.joystick.getJoystickCount() < 1 then return end
   local joystick = love.joystick.getJoysticks()[self.controls.jid]
   if Player.Axes.x == 0 and Player.Axes.y == 0 then
      local axes_x, axes_y = joystick:getAxes(1)
      local axVec = Vec2.new(axes_x, axes_y) 
      Player.Axes = Vec2.threshold(axVec, 0.2) -- Dead zone the stick
   end

   -- Check d-pad
   if Player.Axes.x == 0 and Player.Axes.y == 0 then
      local hat = joystick:getHat(1)
      if     string.find(hat, self.controls.joystick.moveUp)    then Player.Axes.y = -1
      elseif string.find(hat, self.controls.joystick.moveDown)  then Player.Axes.y =  1 end
      if     string.find(hat, self.controls.joystick.moveLeft)  then Player.Axes.x = -1
      elseif string.find(hat, self.controls.joystick.moveRight) then Player.Axes.x =  1 end
   end
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
   if v.x > 0 then
      self.sprite:SetAnimation(self.states.move_right)
   elseif v.x < 0 then
      self.sprite:SetAnimation(self.states.move_left)
   elseif v.y > 0 then
      self.sprite:SetAnimation(self.states.move_right)
   elseif v.y < 0 then
      self.sprite:SetAnimation(self.states.move_left)
   else
      self.sprite:SetAnimation(self.states.idle)
   end
end

-- Player key press event (On Key Down)
function Player:KeyPressed(key, scancode, isrepeat, isdebug)
   -- Debug press controls
   if (isdebug or false) then
      if     key == '.' then self.speed = self.speed + 10 ; print("[DEBUG] Speed = "..self.speed)
      elseif key == ',' then self.speed = self.speed - 10 ; print("[DEBUG] Speed = "..self.speed) end
   end
end

-- Player update event
function Player:Update(dt)
   -- Gather input
   self:GetMotionInput()

   -- Move and animate
   self:SetMove(Player.Axes)
   self:SetSpriteState(Player.Axes)

   -- Update transforms and sprite
   self.entity:Update(dt)
   self.sprite:Update(dt)

   -- Reset
   Player.Axes = Vec2.new()
end

-- Player draw event
function Player:Draw()
   -- Draw shadow
   local shadowPos = self.entity:GetPosition()
   love.graphics.setColor(0, 0, 0, 100)
   love.graphics.ellipse("fill", shadowPos.x, shadowPos.y, 8, 4)
   love.graphics.setColor(255,255,255,255)

   -- Draw Sprite
   self.sprite:Draw(self.entity.transform)
end

-- Player debug draw event
function Player:DrawDebug(color)
   if color then
      love.graphics.setColor(color.r, color.g, color.b)
   else
      love.graphics.setColor(self.color.r, self.color.g, self.color.b)
   end
   local wp = self.entity:GetPosition()

   -- Draw the origin point
   love.graphics.circle("fill", wp.x, wp.y, 3, 5)

   -- Print debug info
   love.graphics.setColor(0, 0, 0, 100)
   love.graphics.rectangle("fill", wp.x-21, wp.y+5, 95, 38)
   if color then
      love.graphics.setColor(color.r, color.g, color.b)
   else
      love.graphics.setColor(self.color.r, self.color.g, self.color.b)
   end
   love.graphics.printf(self.name
			   .. "\nP:" .. Vec2.toString(self.entity:GetPosition())
			   .. "\nV:"..Vec2.toString(self.entity:GetVelocity()),
			wp.x-16,
			wp.y+10,
			200,
			"left");
   love.graphics.setColor(255,255,255)
end

return Player
