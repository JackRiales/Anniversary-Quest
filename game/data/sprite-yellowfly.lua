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

require "love.graphics"

local texture_width = 96
local texture_height= 16
local sprite_tile_size = 16

return {
   texture_url = "assets/images/sheets/YellowFly.png",
   sprite_name = "YellowFly",
   frame_duration = 0.10,
   animation_names = {"default"},
   animations = {
      default = {
	 love.graphics.newQuad(0,  0, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(16, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(32, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(48, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(64, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height)
      }
   }
}
