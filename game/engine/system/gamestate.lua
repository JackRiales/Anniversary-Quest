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

local GameState = {}
GameState.__index = GameState
GameState.StateList = {}
GameState.Current   = nil

function GameState.RegisterNew(name, enter, update, draw, exit)
	local o  = {}
	o.name   = name or "New Game State"
	o.enter  = enter or nil
	o.update = update or nil
	o.draw   = draw or nil
	o.exit   = exit or nil
	GameState.StateList[o.name] = o
	setmetatable(o, GameState)
	return o
end

function GameState:Set()
	GameState.Current.exit()
	GameState.Current = GameState.StateList[self.name]
	GameState.Current.enter()
end

function GameState.Update()
	if GameState.Current and type(GameState.Current.update) == "function" then 
		GameState.Current.update()
	end
end

function GameState.Draw()
	if GameState.Current and type(GameState.Current.draw) == "function" then 
		GameState.Current.draw()
	end
end

return GameState
