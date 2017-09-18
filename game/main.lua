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

function love.load(arg)
  -- Main external asset table
  Assets = require('lib.cargo').init('assets')

  -- Third party GUI system
  require('lib.gooi')

  -- Testing
  gooi.newButton({text = "Quit"}):onRelease( function () love.event.quit() end )
  gooi.newButton({
    text = "Hide UI",
    x = 80,
    y = 40,
    w = 100,
    h = 25
  })

  GameState = require('engine.system.gamestate')
  Quest = require('quest.states.init').load()
  Quest.fighttest:setcurrent()
end

function love.update(dt)
  GameState.update(dt)
end

function love.keypressed(key, scancode, isrepeat)
  GameState.keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button)
  gooi.pressed()
end

function love.mousereleased(x, y, button)
  gooi.released()
end

function love.joystickpressed(joystick, button)
  GameState.joystickpressed(joystick, button)
end

function love.draw()
  GameState.draw()
  gooi.draw()
end