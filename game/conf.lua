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

function love.conf(t)
   -- t.identity = "Anniversary9"
   t.accelerometerjoystick = false

   t.window.title = "Anniversary Quest"
   t.window.icon = nil -- TODO(Jack)
   t.window.width = 1280
   t.window.height = 720
   t.window.fullscreen = false -- TODO(Jack): When done, maybe set to true
end