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
local Collider = require 'base.collider'

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

   self.collider = {}
   self.collider.width = 16
   self.collider.height= 8
   self.collider.rect = Collider.new(self.entity:GetPosition().x-self.collider.width/2,
				     self.entity:GetPosition().y-self.collider.height/2,
				     self.collider.width, self.collider.height)

   self.bullets = {}
   self.shot = self.data.shot
   self.shot.sprite = Sprite.new(self.data.shot.sprite)
   self.shot.direction = Vec2.new(0, 1)
   self.shot.time = 0
   self.shooting = false
   
   return setmetatable(self, Player)
end

function Player:SetKeyboardControls(controls)
   self.controls.keys.moveUp   = controls.moveUp   or "w"
   self.controls.keys.moveDown = controls.moveDown or "s"
   self.controls.keys.moveLeft = controls.moveLeft or "a"
   self.controls.keys.moveRight= controls.moveRight or "d"
   self.controls.keys.shootUp  = controls.shootUp or "up"
   self.controls.keys.shootDown= controls.shootDown or "down"
   self.controls.keys.shootLeft= controls.shootLeft or "left"
   self.controls.keys.shootRight = controls.shootRight or "right"
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

function Player:GetShootInput()
   if     love.keyboard.isDown(self.controls.keys.shootUp)    then
      self.shot.direction = Vec2.new(0,-1) ; self.shooting = true
   elseif love.keyboard.isDown(self.controls.keys.shootDown)  then
      self.shot.direction = Vec2.new(0,1) ; self.shooting = true
   elseif love.keyboard.isDown(self.controls.keys.shootLeft)  then
      self.shot.direction = Vec2.new(-1,0) ; self.shooting = true
   elseif love.keyboard.isDown(self.controls.keys.shootRight) then
      self.shot.direction = Vec2.new(1,0) ; self.shooting = true
   else self.shot.direction = Vec2.new() ; self.shooting = false end
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
function Player:KeyPressed(key, scancode, isrepeat, isdebug)
   -- Debug press controls
   if (isdebug or false) then
      if     key == '>' then self.speed = self.speed + 10 ; print("Speed = "..self.speed)
      elseif key == '<' then self.speed = self.speed - 10 ; print("Speed = "..self.speed) end
   end
end

-- Player update event
function Player:Update(dt)
   -- Gather input
   self:GetMotionInput()
   self:GetShootInput()

   -- Set collider
   self.collider.rect:Set(self.entity:GetPosition().x-self.collider.width/2,
			  self.entity:GetPosition().y-self.collider.height/2,
			  self.collider.width, self.collider.height)
   local collisions = self.collider.rect:Check()
   if #collisions > 1 then
      -- TODO(Jack)
   end

   -- Shooting
   self.shot.time = self.shot.time + dt
   if self.shooting then
      if self.shot.time > self.shot.rate then
	 -- TODO(Jack): Add pooling; move to class
	 local bullet = {}
	 bullet.time = 0
	 bullet.entity = Entity.new("bullet")
	 bullet.entity:SetPosition(self.entity:GetPosition().x-8, self.entity:GetPosition().y-8)
	 local bvel = Vec2.scale(Vec2.normalized(self.shot.direction), self.shot.speed)
	 bullet.entity:SetVelocity(bvel.x, bvel.y)
	 bullet.entity:SetAcceleration(-bvel.x/2, -bvel.y/2)

	 bullet.sprite = self.shot.sprite
	 table.insert(self.bullets, bullet)
	 self.shot.time = 0
      end
   end
   for i,value in ipairs(self.bullets) do
      value.time = value.time + dt
      if value.time > self.shot.ttl then table.remove(self.bullets, i) end
      value.entity:Update(dt)
      value.entity:SetRotation(value.entity:GetRotation()+1)
   end
   self.shot.sprite:Update(dt)

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

   -- Draw bullets
   for i,value in ipairs(self.bullets) do
      value.sprite:Draw(value.entity.transform)
   end
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

   -- Draw the collider
   love.graphics.rectangle("line",
			   self.collider.rect.x,
			   self.collider.rect.y,
			   self.collider.rect.w,
			   self.collider.rect.h)
   
   -- Print debug info
   PrintWrapped(wp.x-16, wp.y, 10, {self.name,
				    "P:"..Vec2.toString(self.entity:GetPosition()),
				    "V:"..Vec2.toString(self.entity:GetVelocity()),
				    "Shot:"..Vec2.toString(self.shot.direction).." "..tostring(self.shooting)})
   love.graphics.setColor(255,255,255)
end

return Player
