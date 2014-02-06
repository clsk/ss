Game = require "Game"
local Point = require "Point"
local Utils = require "Utils"

weaponsImage = love.graphics.newImage("images/weapons.png")
weaponsQuads = {
    ["singleFire"] = love.graphics.newQuad(224, 96, 32, 32, weaponsImage:getWidth(), weaponsImage:getHeight())
}
local Bullet = {}
Bullet.__index = Bullet
function Bullet.new(pos, radianOffset)
    local self = setmetatable({}, Bullet)
    self.pos = Point.new()
    self.pos.x = pos.x - 16
    if radianOffset < 6 then
        self.pos.x = self.pos.x + radianOffset*9
    else
        self.pos.x = self.pos.x + radianOffset*4
    end
    self.pos.y = pos.y+1

    self.radianOffset = radianOffset
    self.velocity = Point.new(math.cos(self.radianOffset), math.sin(self.radianOffset))
    print(self.pos.y)
    print(radianOffset)

    return self
end

function Bullet.calc()

end

function Bullet:update(dt)
    self.pos.x = self.pos.x + self.velocity.x + dt
    self.pos.y = self.pos.y - self.velocity.y - dt

    for key, enemy in pairs(Game.scene.enemies) do
        if Utils.checkCollision(self.pos.x, self.pos.y, 8, 4, enemy.pos.x, enemy.pos.y, enemy.quadWidth*.75, enemy.quadHeight) then
            Game.scene:removeEnemy(key)
            return false
        end
    end

    if self.pos.x > Game.dimensions.x or self.pos.x < 0 or self.pos.y > Game.dimensions.y or self.pos.y < 0 then
        return false
    else
        return true
    end
end

function Bullet:draw()
    love.graphics.draw(weaponsImage, weaponsQuads["singleFire"], self.pos.x, self.pos.y, -self.radianOffset)
end

return Bullet;
