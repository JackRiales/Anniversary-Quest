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

print("SprCyan data loaded")

require "love.graphics"

return {
   -- This version of the serialization process. May change.
   serial_ver = 1.0 

   -- Location of the image file
   texture_url = "assets/spr/SprCyan.png"

   -- Width and height of the texture
   -- Not necessarily needed, since LOVE has methods to get these,
   -- but it's nice to have for defining quads down below
   texture_width = 128
   texture_height= 32

   -- Tile width. Again, not necessarily needed but nice for readability
   sprite_tile_size = 32

   -- Name used for this sprite sheet
   sprite_name = "Cyan"

   -- Duration of frames, in ms
   frame_duration = 100

   -- Animation definitions
   animation_names = {
      "Dance"
   }
   animations = {
      dance = {
	 love.graphics.newQuad(0, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height)
	 love.graphics.newQuad(32, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height)
	 love.graphics.newQuad(64, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height)
	 love.graphics.newQuad(96, 0, sprite_tile_size, sprite_tile_size, texture_width, texture_height)
      }
   }
}
