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

local function Init_Enter()
end

local function Init_Update()
end

local function Init_Draw()
end

local function Init_Exit()
end

local GSInit = GameState.RegisterNew("Init",
                                     Init_Enter,
                                     Init_Update,
                                     Init_Draw,
                                     Init_Exit)
return GSInit
