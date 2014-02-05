local Point = {}
Point.__index = Point
function Point.new(x, y)
    local self = setmetatable({}, Point)
    self.x = x or 0
    self.y = y or 0
    return self
end

return Point;
