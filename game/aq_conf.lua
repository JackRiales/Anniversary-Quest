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

-- Anniversary Quest configurations
local AQ = {}             -- Global Anniversary Quest object with information about the game.
AQ.Framerate      = 60    -- We want the standard framerate to be 60, when it's being operated on without vsync
AQ.CanvasWidth    = 256   -- Width of the rendered canvas. Effectively how many pixels we're working on.
AQ.CanvasHeight   = 256   -- ^ ... this scales the graphics upwards to whatever the window size is.
AQ.GUICanvasWidth = 128   -- The canvas for the GUI can have a different size than the standard.
AQ.GUICanvasHeight= 128   -- I like it lower, for now.

-- Anniversary quest folder configuration
AQ.AssetPath      = "assets/"
AQ.ImagePath      = AQ.AssetPath.."images/"
AQ.MusicPath      = AQ.AssetPath.."music/"
AQ.FontPath       = AQ.AssetPath.."fonts/"
AQ.DataPath       = AQ.AssetPath.."data/"
AQ.MapPath        = AQ.DataPath.."map-data/"

return AQ;
