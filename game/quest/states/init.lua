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

local GameState = require 'engine.system.gamestate'
local QuestStates = {}

function QuestStates.load()
  local statefiles = love.filesystem.getDirectoryItems("quest/states")
  for _, file in ipairs(statefiles) do
    if file ~= "init.lua" then -- don't try and register the initializer
      local title = string.sub(file, 1, #file-4)
      QuestStates[title] = GameState.register(require('quest.states.'..title))
    end
  end
  return QuestStates
end

return QuestStates