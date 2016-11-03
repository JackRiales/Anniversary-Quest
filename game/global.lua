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

-- This file is meant to contain a global table, where certain constants I need are held

local GLOBAL = {}

-- Window properties, for convenience
GLOBAL.WINDOW_WIDTH     = love.graphics.getWidth()
GLOBAL.WINDOW_HEIGHT    = love.graphics.getHeight()

-- Preferred FPS
GLOBAL.FRAMERATE        = 60

-- Frame buffer resolution
-- Effectively, the resolution for everything in the main game display
GLOBAL.PIXEL_WIDTH      = 256
GLOBAL.PIXEL_HEIGHT     = 256

-- GUI buffer resolution
-- I wanted the GUI to be a different resolution than the frame buffer,
-- so that's defined right here
GLOBAL.GUI_PIXEL_WIDTH  = 128
GLOBAL.GUI_PIXEL_HEIGHT = 128

-- Asset paths
-- Using these instead of hardcoding paths, so I don't have to work as hard
-- when I rearrange things. That gets to be a big hassle...
GLOBAL.ASSET_PATH = "assets/"
GLOBAL.IMAGE_PATH = GLOBAL.ASSET_PATH.."images/"
GLOBAL.MUSIC_PATH = GLOBAL.ASSET_PATH.."music/"
GLOBAL.FONT_PATH  = GLOBAL.ASSET_PATH.."fonts/"

GLOBAL.DATA_PATH  = "data/"
GLOBAL.MAP_PATH   = GLOBAL.DATA_PATH.."map-data/"

return GLOBAL
