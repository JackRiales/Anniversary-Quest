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

return {
   -- General info
   name   = "Cyan",
   color  = { r = 0, g = 255, b = 255 },

   -- Movement
   speed  = 140,
   accel  = 400,

   -- Shot definition
   shot = {
      sprite = "",
      color  = { r = 255, g = 255, b = 255 },
      effects= {}
   },
   
   -- Sprite definition
   sprite = "data.Sprite-Cyan",

   -- Animation names
   states = {
      idle = "dance",
      move_left = "walk_left",
      move_right= "walk_right",
      die       = nil  -- TODO
   }
}
