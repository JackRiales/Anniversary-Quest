-- Base Object used to prototype other objects
-- Since lua is a prototype based lang, this is necessary...
-- This allows for classes, instantiation, and even inheritance.

-- Credit where credit's due, I got help from here:
-- https://love2d.org/forums/viewtopic.php?t=82318

local oo = {}
local meta = {}
local rmeta = {}

-- Creates a new class type
function oo.class()
   local c = {}
   local tbl = { __index = c }
   meta[c] = tbl
   rmeta[tbl] = c
   return c
end

-- Creates a subclass of the given parent
function oo.subclass(parent)
   assert(meta[parent], "Parent class is undefined")
   local c = oo.class()
   return setmetatable(c, meta[p])
end

-- Creates an instance of a class
function oo.instance(class)
   assert(meta[c], "Class is undefined")
   return setmetatable({}, meta[c])
end

return oo
