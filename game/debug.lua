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

-- Global debug flags
DEBUGFlags = {
   UPDATE   = true, -- Turn off updates (except for debug commands)
   DRAW     = true, -- Turn this off to disable rendering completely
   DRAW_DBG = true, -- Whether or not to draw debug displays
   DRAW_MAP = true, -- Draw the map
   DRAW_ENT = true, -- Draw entities
   DRAW_GUI = true  -- Whether or not to draw gui
}

-- Message stack
local _messages = {}
local _lineSpacing = 15

local function DEBUGErrorHandler(err)
   local msg = {}
   msg.text = err
   msg.color = {r=255, g=25, b=25}
   table.insert(_messages, msg)
end

-- Draw errors onscreen
local function DEBUGErrorDraw()
   for i,v in messages do
      love.graphics.setColor(v.color.r, v.color.g, v.color.b)
      love.graphics.print(v.text, 0, (i-1)*_lineSpacing)
   end
   love.graphics.setColor(255,255,255)
end

-- Draw a user defined message to the screen as if it were an error
function DEBUGLog(message, color)
   local msg = {}
   msg.text = message
   msg.color = color
   table.insert(_messages, msg)
end

function DEBUGDraw()
   if not DEBUGFlags.DRAW or not DEBUGFlags.DRAW_DBG then return end
   DEBUGErrorDraw()
end
