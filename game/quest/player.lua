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
local Transform = require 'engine.system.transform'
local Sprite = require 'engine.graphics.sprite'

Player = {}
Player.__index = Player
Player.Bank = {}

-- Control configurations
Player.Controls = {}
Player.Controls.Keys = {
  moveUp   = 'w',
  moveDown = 's',
  moveLeft = 'a',
  moveRight= 'd',
}

Player.Controls.Joystick = {
  moveUp   = "u", -- hat up
  moveDown = "d", -- hat down
  moveLeft = "l", -- hat left
  moveRight= "r"  -- hat right
}

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

   local self = Player.Bank[def]

   self.axes     = Vec2.new()
   self.inputId  = 1 -- joystick id

   self.transform = Transform.new()
   self.sprite = Sprite.new(self.sprite)

   return setmetatable(self, Player)
end

function Player:SetKeyboardControls(controls)
   Player.Controls.Keys.moveUp   = controls.moveUp   or "w"
   Player.Controls.Keys.moveDown = controls.moveDown or "s"
   Player.Controls.Keys.moveLeft = controls.moveLeft or "a"
   Player.Controls.Keys.moveRight= controls.moveRight or "d"
end

function Player:GetMotionInput()
   -- Check keyboard input
   if     love.keyboard.isDown(Player.Controls.Keys.moveUp)    then self.axes.y = -1
   elseif love.keyboard.isDown(Player.Controls.Keys.moveDown)  then self.axes.y =  1 end
   if     love.keyboard.isDown(Player.Controls.Keys.moveLeft)  then self.axes.x = -1
   elseif love.keyboard.isDown(Player.Controls.Keys.moveRight) then self.axes.x =  1 end

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
      if     string.find(hat, Player.Controls.Joystick.moveUp)    then self.axes.y = -1
      elseif string.find(hat, Player.Controls.Joystick.moveDown)  then self.axes.y =  1 end
      if     string.find(hat, Player.Controls.Joystick.moveLeft)  then self.axes.x = -1
      elseif string.find(hat, Player.Controls.Joystick.moveRight) then self.axes.x =  1 end
   end
end

-- Sets the movement vector based on the given vector (input axes)
function Player:SetMove(v)
  self.transform:Translate(v)
  --[[
  -- If the axes are 0, introduce a stopping force (opposite velocity)
   if v.x == 0 and v.y == 0 then
      v = Vec2.threshold(Vec2.scale(self.entity:GetVelocity(), -1), 1)
   end

   -- TODO(Jack) Decide to have motion properties in Transform or
   --            loosely inside objects. It's not... THAT necessary
   --            for ~everything~ to have motion properties.

   
   -- Set the acceleration from the axes
   local motion = Vec2.scale(Vec2.normalized(v), self.accel)
   self.entity:SetAcceleration(motion.x, motion.y)

   -- Ensure velocity never crosses speed
   local trimmedVel = Vec2.trim(self.entity:GetVelocity(), self.speed)
   self.entity:SetVelocity(trimmedVel.x, trimmedVel.y)
   --]]
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
   self:SetMove(self.axes)
   self:SetSpriteState(self.axes)

   -- Update transforms and sprite
   -- self.entity:Update(dt)
   self.sprite:Update(dt)

   -- Reset
   self.axes = Vec2.new()
end

-- Player draw event
function Player:Draw()
   -- Draw shadow
   local shadowPos = self.transform.Position
   love.graphics.setColor(0, 0, 0, 100)
   love.graphics.ellipse("fill", shadowPos.x, shadowPos.y, 8, 4)
   love.graphics.setColor(255,255,255,255)

   -- Draw Sprite
   self.sprite:Draw(self.transform.Position, self.transform.Rotation, self.transform.Scale)
end

-- Player debug draw event
function Player:DrawDebug(color)
   if color then
      love.graphics.setColor(color.r, color.g, color.b)
   else
      love.graphics.setColor(self.color.r, self.color.g, self.color.b)
   end
   local wp = self.transform.Position

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
			   .. "\nP:" .. Vec2.toString(self.transform.Position)
			   .. "\nV:"..Vec2.toString(self.transform.Position),
			wp.x-16,
			wp.y+10,
			200,
			"left");
   love.graphics.setColor(255,255,255)
end

return Player
