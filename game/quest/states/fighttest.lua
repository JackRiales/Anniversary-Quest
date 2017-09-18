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

local _state = {}
_state.name = "Fighting Test"
_state.x, _state.y = 10,10

-- Always load assets and do transitions
function _state.enter()

end

function _state.update(dt)
  
end

function _state.keypressed(key, scancode, isrepeat)
  function b2i(b) if b then return 1 else return -1 end end
  local dx = (b2i(key == 'right' and isrepeat) - b2i(key == 'left' and isrepeat)) * 10
  local dy = (b2i(key == 'down' and isrepeat) - b2i(key == 'up' and isrepeat)) * 10
  _state.x = (_state.x + dx) % love.graphics.getWidth()
  _state.y = (_state.y + dy) % love.graphics.getHeight()
end

function _state.joystickpressed(joystick, button)

end

function _state.draw()
  love.graphics.print(_state.name, _state.x, _state.y)
end

-- Always unload assets and do transitions here
function _state.exit()
end

return _state