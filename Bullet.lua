Game = require "Game"
Point = require "Point"

weaponsImage = love.graphics.newImage("images/weapons.png")
weaponsQuads = {
    ["singleFire"] = love.graphics.newQuad(224, 96, 32, 32, weaponsImage:getWidth(), weaponsImage:getHeight())
}
local Bullet = {}
Bullet.__index = Bullet
function Bullet.new(pos, radianOffset)
    local self = setmetatable({}, Bullet)
    local x = pos.x or Game.dimensions.x/2
    local y = pos.y or Game.dimensions.y
    self.pos = Point.new(x,y)
    self.radianOffset = radianOffset
    return self
end

function Bullet:update(dt)
    --self.pos.y = self.pos.y-1
    self.pos.x = self.pos.x - math.cos(self.radianOffset)
    self.pos.y = self.pos.y - math.sin(self.radianOffset)
end

function Bullet:draw()
    love.graphics.draw(weaponsImage, weaponsQuads["singleFire"], self.pos.x, self.pos.y+16, ( ( 3*(22/7) ) / 2) + self.radianOffset )
    
end

return Bullet;
