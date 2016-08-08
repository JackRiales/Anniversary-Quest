-- Entity.lua
-- Defines a generic entity, that reacts to "physics" and
-- can be interacted with (ideally).

-- Global entity table
Entity_InstanceTable = {}
Entity_UIDDispatch = 0

-- Initializes a new instance of an entity
function Entity_Init(name)
   local self = {}
   self.name = name or "New Entity"
   self.transform = {}
   self.transform.angle    = 0
   self.transform.position = { x = 0, y = 0 }
   self.transform.scale    = { x = 1, y = 1 }
   self.transform.origin   = { x = 0, y = 0 }
   self.transform.shear    = { x = 0, y = 0 }

   self.size     = 0
   
   self.flUpdate = false -- Is this allowed to update?
   self.flDraw   = false -- Is this allowed to draw?

   -- Add to the entity table
   Entity_InstanceTable[Entity_UIDDispatch] = self
   Entity_UIDDispatch = Entity_UIDDispatch + 1

   return self;
end

-- Draws an entity with the given graphic to the given target (or screen, if nil)
function Entity_Draw(entity, graphic, target)
   if entity.flDraw == false or not graphic then
      return
   end
   love.graphics.setCanvas(target)
   love.graphics.draw(graphic,
		      entity.transform.position.x,
		      entity.transform.position.y,
		      entity.transform.angle*(180/3.14),
		      entity.transform.scale.x,
		      entity.transform.scale.y,
		      entity.transform.origin.x,
		      entity.transform.origin.y,
		      entity.transform.shear.x,
		      entity.transform.shear.y)
   love.graphics.setCanvas(nil)
end
