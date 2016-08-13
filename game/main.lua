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

-- Anniversary Quest
-- by Jack Riales
--
-- P.S. If you find yourself reading this, I love you! Happy 9th.
-- I'm actually writing this on August 7th. Pretty crazy right?
-- Anyway, I hope you enjoy.

-- Dependencies
local Player = require 'player'

-- Main globals
DEBUG = true

-- Main load
function love.load()
   -- Extra graphics settings
   love.graphics.setDefaultFilter("nearest","nearest")

   -- Load assets
   fntJoystix = love.graphics.newFont("assets/fonts/pixelfj.ttf", 8)
   sprDungeon = love.graphics.newImage("assets/spr/BGRoom-Dungeon.png")
   sprCyanPortrait = love.graphics.newImage("assets/spr/CyanPortrait.png")
   sprIcons   = love.graphics.newImage("assets/spr/SprIcons.png")

   -- Icon quads
   qIconHeart = love.graphics.newQuad(0, 0, 16, 16, 80, 16)
   qIconPhantomHeart = love.graphics.newQuad(16, 0, 16, 16, 80, 16)
   qIconCoin  = love.graphics.newQuad(32, 0, 16, 16, 80, 16)
   qIconBomb  = love.graphics.newQuad(48, 0, 16, 16, 80, 16)
   qIconKey   = love.graphics.newQuad(64, 0, 16, 16, 80, 16)
   
   -- Set cursor
   imgCursor = love.graphics.newImage("assets/spr/Cursor.png")
   Cursor = love.mouse.newCursor(imgCursor:getData(), imgCursor:getWidth()/2, imgCursor:getHeight()/2)
   love.mouse.setCursor(Cursor)
   
   -- Drawing canvas
   FrameBuffer = {}
   FrameBuffer.width  = 256
   FrameBuffer.height = 256
   FrameBuffer.canvas = love.graphics.newCanvas(FrameBuffer.width, FrameBuffer.height)
   FrameBuffer.scale  = love.graphics.getHeight()/FrameBuffer.canvas:getHeight()
   FrameBuffer.offset = {
      x = love.graphics.getWidth()/2 - (FrameBuffer.canvas:getWidth()*FrameBuffer.scale)/2,
      y = 0
   }

   -- Player object loading from definition file
   Cyan = Player.new("data.player-cyan")
   Cyan.entity:SetOrigin(16,32)
   Cyan.entity:SetPosition(64, 64)
end

-- Main input key-pressed
function love.keypressed(key, scancode, isrepeat)
   -- Check for toggle debug
   if key == "`" then
      if DEBUG then DEBUG = false
      else DEBUG = true end
   end
   
   -- Check for leave
   if key == "escape" then
      local buttons = {"NO!", "Yep!", escapebutton = 1}
      local quit = love.window.showMessageBox("Confirmation",
					      "Are you sure you want to exit?",
					      buttons);
      if (quit == 2) then love.event.push('quit'); end
   end

   -- Player keypress events
   Cyan:KeyPressed(key, scancode, isrepeat, DEBUG)
end

-- Main Update
function love.update(dt)
   Cyan:Update(dt)
end

-- Main Draw
function love.draw()
   -- Draw game to canvas
   love.graphics.setCanvas(FrameBuffer.canvas)
   love.graphics.clear(50, 100, 75)

   -- Draw game
   love.graphics.draw(sprDungeon, 0, 0)
   Cyan:Draw()

   -- Draw ui (just proof of concept, doesn't actually do anything)
   love.graphics.setColor(10,10,10,100)
   love.graphics.rectangle("fill", 5,5,68,26)
   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(sprIcons, qIconHeart, 10, 10)
   love.graphics.draw(sprIcons, qIconHeart, 31, 10)
   love.graphics.draw(sprIcons, qIconHeart, 52, 10)
   
   -- Draw debug
   if DEBUG then
      love.graphics.setFont(fntJoystix)
      Cyan:DrawDebug()
   end
   love.graphics.setCanvas()

   -- Draw the frame buffer
   love.graphics.draw(FrameBuffer.canvas,
		      FrameBuffer.offset.x,
		      FrameBuffer.offset.y,
		      0,
		      FrameBuffer.scale,
		      FrameBuffer.scale)
   
   -- Debug info
   if not DEBUG then return end
   love.graphics.rectangle("line",
			   FrameBuffer.offset.x,
			   FrameBuffer.offset.y,
			   FrameBuffer.canvas:getWidth()*FrameBuffer.scale,
			   FrameBuffer.canvas:getHeight()*FrameBuffer.scale)
   
   love.graphics.setColor(0, 255, 0, 100)
   love.graphics.rectangle("fill", 5, 5, 180, 50)
   love.graphics.setColor(255, 255, 255)
   love.graphics.print(string.format("LOVE Ver: %d.%d.%d - %s",love.getVersion()), 10, 10)
   love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 25)
end
