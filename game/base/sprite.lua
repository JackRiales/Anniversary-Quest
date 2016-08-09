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

local Sprite = {}
Sprite.__index = Sprite

-- Creates a new sprite with the given definition object
function Sprite.new(def)
end

--[[
function Sprite.new(name, texture, frameRate, frames)
   local self = {}
   self.name   = name or "New Sprite"
   self.texture= texture
   self.rate   = frameRate or 30
   self.frames = frames or {}
   self.loops  = {}
   self.anim   = nil
   return setmetatable(self, Sprite)
end

function Sprite:AddFrame(vx, vy, vw, vh)
   table.insert(self.frames, love.graphics.newQuad(vx, vy, vw, vh,
						   self.texture:getWidth(),
						   self.texture:getHeight()))
end

function Sprite:SetLoopSection(start, stop, name)
   name = name or "Loop"
   self.loops[name] = {start = start, stop = stop}
end

function Sprite:SetAnimation(name)
   assert(self.loops[name], "No loop by the name "..name.." found in "..self.name)
   self.anim = self.loops[name]
end

function Sprite:Update(dt)

end

function Sprite:Draw(target)

   end
--]]

return Sprite
