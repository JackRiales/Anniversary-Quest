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

   Button = {}
   Button.__index = Button

-- Creates a new instance of button
function Button.new(rect, onclick, onhover, onexit)
 local self  = {}
 self.active = true
 self.rect   = rect
 self.onclick = onclick or nil
 self.onhover = onhover or nil
 self.onexit  = onexit or nil
 self._hovering  = false
 self._clicked   = false
 self._hoverlock = false
 self._clicklock = false
 return setmetatable(self, Button)
end

function Button:update(dt)
 if not self.active then return end
 
   -- Check if button is being hovered
   -- This is probably going to be inaccurate because of scaling...
   -- TODO(Jack): Make class for frame buffers to get proper mouse position
   local x, y = love.mouse.getPosition()
   if self.rect:CheckPoint({x=x, y=y}) then
      self._hovering = true
      if not self._hoverlock and type(self.onhover)=='function' then
         self.onhover()
     end
     self._hoverlock = true
 else
     self._hovering = false
     self._hoverlock = false
     if type(self.onexit)=='function' then
        self.onexit()
    end
end

   -- Check if button is being clicked
   if self._hovering and love.mouse.isDown(1) then
      self._clicked = true
      if not self._clicklock and type(self.onclick)=='function' then
         self.onclick()
         self._clicklock = true
     end
 else
     self._clicked = false
     self._clicklock = false
 end
end

function Button:DrawTooltip(tooltip, bgColor, fntColor)
 if not self._hovering then return end
   -- TODO(Jack): When text box is finished, use it here
end

function Button:DrawDebug(color)
 color = color or {r=255,g=255,b=255,a=255}
 love.graphics.setColor(color.r, color.g, color.b, color.a)
 love.graphics.rectangle("line", self.rect.x, self.rect.y, self.rect.w, self.rect.h)
 love.graphics.setColor(255,255,255,255)
end

function Button:IsHovered()
 return self._hovering
end

function Button:IsClicked()
 return self._clicked
end

function Button:SetActive(bool)
 self.active = bool
end

function Button:SetRect(rect)
 self.rect = rect
end

return Button
