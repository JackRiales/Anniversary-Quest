-- Cyan's Adventure to Save the Things 2
-- by Jack Riales
--
-- P.S. If you find yourself reading this, I love you! Happy 9th.
-- I'm actually writing this on August 7th. Pretty crazy right?
-- Anyway, I hope you enjoy.

-- Dependencies

-- Main load
function love.load()
   -- Prototyping!

   -- TODO(Jack): Find a way to load these out from a data file (tiled?)
   
   -- Create a room to walk around in
   Room = {};
   Room.color = {
      r = 95,
      g = 87,
      b = 79
   }
   Room.bounds = {
      x = 50,
      y = 20,
      w = 1180,
      h = 680,
   }
   Room.draw = function()
      love.graphics.setColor(Room.color.r, Room.color.g, Room.color.b)
      love.graphics.rectangle("fill",
			      Room.bounds.x,
			      Room.bounds.y,
			      Room.bounds.w,
			      Room.bounds.h)
   end
   
   -- ... and a thing to move in it
   Entity = {};
   Entity.size = 32
   Entity.speed = 80
   Entity.transform = {
      x = 0,
      y = 0
   }
   Entity.color = {
      r = 255,
      g = 0,
      b = 77
   }
   Entity.collider = {
      x = 0, -- local to the origin
      y = 0, -- local to the origin
      w = Entity.size,
      h = Entity.size
   }

   function Entity.update(dt)
      if (love.keyboard.isDown("w")) then
	 Entity.transform.y = Entity.transform.y - dt * Entity.speed
      elseif (love.keyboard.isDown("s")) then
	 Entity.transform.y = Entity.transform.y + dt * Entity.speed
      end
      
      if (love.keyboard.isDown("a")) then
	 Entity.transform.x = Entity.transform.x - dt * Entity.speed
      elseif
      (love.keyboard.isDown("d")) then
	 Entity.transform.x = Entity.transform.x + dt * Entity.speed
      end
   end
   
   function Entity.draw()
      love.graphics.setColor(Entity.color.r, Entity.color.g, Entity.color.b)
      love.graphics.rectangle("fill",
			      Entity.transform.x,
			      Entity.transform.y,
			      Entity.size,
			      Entity.size)
      love.graphics.setColor(0, 228, 54)
      love.graphics.rectangle("line",
			      Entity.transform.x + Entity.collider.x,
			      Entity.transform.y + Entity.collider.y,
			      Entity.collider.w,
			      Entity.collider.h)
   end
end

-- Main Update
function love.update(dt)
   Entity.update(dt)
end

-- Main Draw
function love.draw()
   Room.draw()
   Entity.draw()
end
