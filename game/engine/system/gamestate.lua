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

function GameState.register(state)
	local st = {
		name = state.name or "New Game State",
		enter = state.enter or nil,
		update = state.update or nil,
		draw = state.draw or nil,
		keypressed = state.keypressed or nil,
		joystickpressed = state.joystickpressed or nil,
		exit = state.exit or nil
	}
	GameState.StateList[st.name] = st
	return setmetatable(st, GameState)
end

function GameState:setcurrent()
	if GameState.Current and type(GameState.Current.exit) == "function" then
		GameState.Current.exit()
	end
	GameState.Current = GameState.StateList[self.name]
	if GameState.Current and type(GameState.Current.enter) == "function" then
		GameState.Current.enter()
	end
end

function GameState.update(dt)
	if GameState.Current and type(GameState.Current.update) == "function" then 
		GameState.Current.update(dt)
	end
end

function GameState.keypressed(key, scancode, isrepeat)
	if GameState.Current and type(GameState.Current.keypressed) == "function" then
		GameState.current.keypressed(key, scancode, isrepeat)
	end
end

function GameState.joystickpressed(joystick, button)
	if GameState.Current and type(GameState.Current.joystickpressed) == "function" then
		GameState.current.joystickpressed(joystick, button)
	end
end

function GameState.draw()
	if GameState.Current and type(GameState.Current.draw) == "function" then 
		GameState.Current.draw()
	end
end

return GameState
