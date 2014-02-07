Game = require "Game"
local Point = require "Point"
local Utils = require "Utils"

local Bullet = {}
Bullet.__index = Bullet

Bullet.weaponsImage = love.graphics.newImage("images/weapons.png")
Bullet.weaponsQuads = {
    ["singleFire"] = love.graphics.newQuad(224, 96, 32, 32, Bullet.weaponsImage:getWidth(), Bullet.weaponsImage:getHeight()),
    ["hellFire"]   = love.graphics.newQuad(224, 160, 32, 32, Bullet.weaponsImage:getWidth(), Bullet.weaponsImage:getHeight())
}

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
    self.velocity = Point.new(math.cos(self.radianOffset) * 4, math.sin(self.radianOffset) * 4)

    return self
end

function Bullet:update(dt)
    self.pos.x = self.pos.x + self.velocity.x + dt
    self.pos.y = self.pos.y - self.velocity.y - dt

    for key, enemy in pairs(Game.scene.enemies) do
        if Utils.checkCollision(self.pos.x, self.pos.y, 8, 4, enemy.pos.x, enemy.pos.y, enemy.quadWidth*.75, enemy.quadHeight) then
            Game.scene:enemyKilled(key)
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
    love.graphics.draw(Bullet.weaponsImage, Bullet.weaponsQuads["singleFire"], self.pos.x, self.pos.y, -self.radianOffset)
end

return Bullet;
