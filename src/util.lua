-- Lua Utility Class -- for games!

-- Bounding box intersection function
-- Returns true if the two rects overlap
-- x and y are the top left coords of each rect,
-- and w and h are obviously width and height.
function BoundsIntersect(x1, y1, w1, h1,
			 x2, y2, w2, h2)
   return
      x1 < x2 + w2 and
      x2 < x1 + w1 and
      y1 < y2 + h2 and
      y2 < y1 + h1
end

-- Same function, but with metatables
function TblBoundsIntersect(b1, b2)
   return
      b1.x < b2.x + b2.w and
      b2.x < b1.x + b1.w and
      b1.y < b2.y + b2.h and
      b2.y < b1.y + b1.h
end
