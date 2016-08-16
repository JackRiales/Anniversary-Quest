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

Game = {}
Game.__index = Game

GameState = {}
GameState.__index = GameState

Game.states = {}
Game.stateStack = {}
Game.cState = {}

function Game.CreateState(def)
   if not def then return nil end
   local state = require(def)
   assert(state, ""..def.." could not be loaded.")
   table.insert(Game.states, setmetatable(state, GameState))
end

function Game.PushState(name)
   assert(Game.states[name] ~= nil, "Game.PushState - State of name "..name.." does not exist")
   table.insert(Game.stateStack, Game.states[name])
end

function Game.MountObject(object)
   assert(type(object)=='table', "Game.MountObject - Object not a table")
   
end

function GameState:KeyPressed(key, scancode, isrepeat, isdebug)
end

function GameState:Update(dt)
end

function GameState:Draw()
end

return Game
