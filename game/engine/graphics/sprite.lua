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

-- Credit where credit's due, I got help from this tutorial here!
-- http://www.buildandgun.com/2014/07/animated-sprites-in-love2d.html

local Vec2 = require 'engine.math.vector'

local Sprite = {}    -- Main class
Sprite.Bank = {}     -- Map of all sprite definitions
Sprite.Textures = {} -- Map of all loaded texture images
Sprite.__index = Sprite

-- Creates a new sprite with the given definition file
function Sprite.load(def)
   -- Error check
   if not def then return nil end

   -- Run the definition and save it
   local spr = require(def)
   if not spr then
      print("Definition file "..def.." returned nil.")
      return nil
   end
   Sprite.Bank[def] = spr

   -- Load image
   local texture = Sprite.Bank[def].texture_url
   Sprite.Textures[texture] = love.graphics.newImage(texture)
   if not Sprite.Textures[texture] then
      print("Defined image url "..texture.." returned nil.")
      return nil
   end
   return Sprite.Bank[def]
end

-- Creates a new sprite instance
function Sprite.new(def)
   if not def then return nil end

   -- If the bank doesn't have def, try to define it
   if not Sprite.Bank[def] then
      if not Sprite.load(def) then return nil end
   end

   -- We're good! Create the object
   local self = Sprite.Bank[def]
   self.cAnimation = self.animation_names[1]
   self.cFrame     = 1
   self.elapTime   = 0
   self.timeScale  = 1

   -- Drawing origin point
   self.origin     = Vec2.new(self.sprite_size / 2, self.sprite_size / 2)

   -- Loop type affects how frames change
   -- Sequence: Simple 1.2.3.1 loop
   -- PingPong: 1.2.3.2.1
   -- Stop:     1.2.3. . .
   self.loopType   = "sequence"
   self.reverse    = false
   
   self.flDraw     = true

   return setmetatable(self, Sprite)
end

function Sprite:SetAnimation(name)
   self.cAnimation = name
end

function Sprite:Update(dt)
   -- Increase elap by dt
   self.elapTime = self.elapTime + dt

   -- Next frame reached
   if self.elapTime > self.frame_duration * self.timeScale then
      if self.loopType == "sequence" then
	 self:_sequenceUpdate()
      elseif self.loopType == "pingpong" then
	 self:_pingPongUpdate()
      elseif self.loopType == "stop" then
	 self:_stopUpdate()
      end
      
      self.elapTime = 0
   end

   -- Safety check
   if self.cFrame > #self.animations[self.cAnimation] then
      self.cFrame = 1
   end
end

function Sprite:Draw(position, angle, scale)
   if not self.flDraw then return end
   love.graphics.draw(
      Sprite.Textures[self.texture_url],
      self.animations[self.cAnimation][self.cFrame],
      position.x,
      position.y,
      math.rad(angle),
      scale,
      scale,
      self.origin.x,
      self.origin.y
   )
end


--------------------------------------------------------
-- "Private" Update functions, for each loop type
--------------------------------------------------------
function Sprite:_sequenceUpdate()
   if not self.reverse then
      if self.cFrame < #self.animations[self.cAnimation] then
	 self.cFrame = self.cFrame + 1
      else
	 self.cFrame = 1
      end
   else
      if self.cFrame > 1 then
	 self.cFrame = self.cFrame - 1
      else
	 self.cFrame = #self.animations[self.cAnimation] - 1
      end
   end
end

function Sprite:_pingPongUpdate()
   if not self.reverse then
      if self.cFrame < #self.animations[self.cAnimation] then
	 self.cFrame = self.cFrame + 1
      else
	 self.reverse = not self.reverse
      end
   else
      if self.cFrame > 1 then
	 self.cFrame = self.cFrame - 1
      else
	 self.reverse = not self.reverse
      end
   end
end

function Sprite:_stopUpdate()
   if self.cFrame < #self.animations[self.cAnimation] then
      self.cFrame = self.cFrame + 1
   end
end

return Sprite
