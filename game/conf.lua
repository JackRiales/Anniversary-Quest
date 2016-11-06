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

-- Cupid debugging system
require 'lib.cupid';

-- LOVE2D Configuration
function love.conf(t)
   t.identity = "AnniversaryQuest"
   t.accelerometerjoystick = false

   t.window.title = "Anniversary Quest"
   t.window.icon = nil -- TODO(Jack)
   t.window.minwidth = 640
   t.window.minheight = 480
   t.window.width = 800
   t.window.height = 600
   t.window.resizable = true

   -- Disabled modules
   t.modules.touch = false
   t.modules.video = false
end
