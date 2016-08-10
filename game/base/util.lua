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

-- Invert the given boolean (true=>false, false=>true)
function InvertBool(bool)
   if bool then
      return false
   else
      return true
   end
end

-- "Casts" a boolean to an integer
function CastBool(bool)
   if bool then
      return 1
   else
      return 0
   end
end

-- Returns a 1 if bool is true, -1 if false
function CastBoolNegative(bool)
   if CastBool(bool) == 0 then
      return -1
   else
      return 1
   end
end
