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

-- Width and height of the texture
-- Not necessarily needed, since LOVE has methods to get these,
-- but it's nice to have for defining quads down below
local texture_width = 128
local texture_height= 128

-- Tile width. Again, not necessarily needed but nice for readability
local sprite_tile_size = 32

return {
   -- Location of the image file
   texture_url = "assets/spr/SprCyan.png",
   
   -- Name used for this sprite sheet
   sprite_name = "Cyan",

   -- Duration of frames, in ms
   frame_duration = 0.10,

   -- Animation definitions
   animation_names = {
      "dance",
      "walk_right",
      "walk_left"
   },
   animations = {
      dance = {
	 love.graphics.newQuad(0,  0, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(32, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(64, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(96, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height)
      },
      walk_right = {
	 love.graphics.newQuad(0, 32, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(32,32, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(64,32, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(96,32, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(0, 64, sprite_tile_size, sprite_tile_size, texture_width, texture_height)
      },
      walk_left = {
	 love.graphics.newQuad(32, 64, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(64, 64, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(96, 64, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(0,  96, sprite_tile_size, sprite_tile_size, texture_width, texture_height),
	 love.graphics.newQuad(32, 96, sprite_tile_size, sprite_tile_size, texture_width, texture_height)
      }
   }
}
