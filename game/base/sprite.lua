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
   local self = {}
   self.sprite     = Sprite.Bank[def]
   self.cAnimation = Sprite.Bank[def].animation_names[1]
   self.cFrame     = 1
   self.elapTime   = 0
   self.timeScale  = 1
   return setmetatable(self, Sprite)
end

function Sprite:Update(dt)
   self.elapTime = self.elapTime + dt
   if self.elapTime > self.sprite.frame_duration * self.timeScale then
      if self.cFrame < #self.sprite.animations[self.cAnimation] then
	 self.cFrame = self.cFrame + 1
      else
	 self.cFrame = 1
      end
      self.elapTime = 0
   end
end

function Sprite:Draw(transform)
   love.graphics.draw(
      Sprite.Textures[self.sprite.texture_url],
      self.sprite.animations[self.cAnimation][self.cFrame],
      transform.position.x,
      transform.position.y,
      transform.angle*(180/3.14),
      transform.scale.x,
      transform.scale.y,
      transform.shear.x,
      transform.shear.y
   )
end

return Sprite
