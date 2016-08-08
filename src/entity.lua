-- Entity.lua
-- Defines a generic entity, that reacts to "physics" and
-- can be interacted with (ideally).

local oo = require 'oo'
local Entity = oo.class()

function Entity:init()
   self.transform = {}
   self.transform.x = 0
   self.transform.y = 0
   self.transform.angle  = 0
   self.transform.scaleX = 1
   self.transform.scaleY = 1
   
   self.flUpdate = false -- Is this allowed to update?
   self.flDraw   = false -- Is this allowed to draw?

   self.gravityScale = 1 -- How much (scale 0...1) is this affected by gravity
end
