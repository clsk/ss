Game = require "Game"
local Utils = require "Utils"
local Point = require "Point"

local Enemy = {}
Enemy.__index = Enemy
Enemy.sprite = love.graphics.newImage('images/enemy.png')
Enemy.quads = {}
Enemy.quadCount = 72
function Enemy.new(pos)
    local self = setmetatable({}, Enemy)
    -- Lazyload quads
    self.width, self.height = self.sprite:getDimensions()
    self.quadWidth = 60
    self.quadHeight = 60
    if table.getn(self.quads) == 0 then
        self.createQuads(self)
    end

    self.pos = Point.new(pos.x, 1) or Point.new(Game.dimensions.x/2, 1)
    self.bullets = {}
    -- Initialization
    self.currentQuad = 0
    self.RADIAN_OFFSET = (2*math.pi) / (self.quadCount)

    return self
end

function Enemy:createQuads()
    local currentCount = 0
    for y = 0, self.height-self.quadHeight, self.quadHeight do
        for x = 0, self.width-self.quadWidth, self.quadWidth do
            if currentCount < self.quadCount then
                table.insert(self.quads, ((y/self.quadHeight)*10) + (x/self.quadWidth), love.graphics.newQuad(x, y, self.quadWidth, self.quadHeight, self.width, self.height))
                currentCount = currentCount + 1
            end
        end
    end
end

-- at self.quadCount/4 player is facing right, thus at 0 degrees
function Enemy:calcOffsetAngle(currentQuad)
    return self.RADIAN_OFFSET*(self.quadCount) - (self.RADIAN_OFFSET*(currentQuad - (self.quadCount/4)))
end

function Enemy:update(dt)
    self.pos.y = self.pos.y + 1

    local player = Game.scene.player
    print(player.pos.x, player.pos.y, player.quadWidth, player.quadHeight, self.pos.x, self.pos.y, self.quadWidth, self.quadHeight)
    if Utils.checkCollision(player.pos.x, player.pos.y, player.quadWidth, player.quadHeight, self.pos.x, self.pos.y, self.quadWidth*0.65, self.quadHeight*0.75) then
        Game.scene:takeLife()
        return false;
    end

    if self.pos.x > Game.dimensions.x or self.pos.x < 0 or self.pos.y > Game.dimensions.y or self.pos.y < 0 then
        return false
    else
        return true
    end
end

function Enemy:draw()
    love.graphics.draw(self.sprite, self.quads[36], self.pos.x, self.pos.y, 0, 0.75, 0.75)
end

return Enemy;
