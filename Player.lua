Game = require "Game"
local Point = require "Point"
local Bullet = require "Bullet"

local Player = {}
Player.__index = Player
function Player.new(sprite, pos)
    local self = setmetatable({}, Player)
    -- Members
    self.sprite = sprite
    self.width, self.height = self.sprite:getDimensions()
    self.quadWidth = self.width / 6
    self.quadHeight = self.height / 12
    self.quads = {}
    self.pos = pos or Point.new(100,100)
    self.bullets = {}
    -- Initialization
    self.createQuads(self)
    self.currentQuad = 0
    self.RADIAN_OFFSET = (2*math.pi) / (table.getn(self.quads)+1)

    return self
end

function Player:createQuads()
    for y = 0, self.height-self.quadHeight, self.quadHeight do
        for x = 0, self.width-self.quadWidth, self.quadWidth do
            table.insert(self.quads, ((y/self.quadHeight)*6) + (x/self.quadWidth), love.graphics.newQuad(x, y, self.quadWidth, self.quadHeight, self.width, self.height))
        end
    end
end

-- at quad 18, player is at 0 degrees
function Player:calcOffsetAngle(currentQuad)
    if currentQuad < 0 then
        return (math.pi/2) - (self.RADIAN_OFFSET*currentQuad)
    elseif currentQuad == 18 then
        return 0
    else
        return self.RADIAN_OFFSET*72 - (self.RADIAN_OFFSET*(currentQuad - 18))
    end
end

function Player:update(dt)
    if love.keyboard.isDown("lshift") then
        if love.keyboard.isDown("right") then
            if (self.currentQuad == 71) then
                self.currentQuad = 0
            else
                self.currentQuad = self.currentQuad+1
            end
        elseif love.keyboard.isDown("left") then
            if (self.currentQuad == 0) then
                self.currentQuad = 71
            else
                self.currentQuad = self.currentQuad-1
            end
        end
    else
        if love.keyboard.isDown("left") and self.pos.x > 0 then
            self.pos.x = self.pos.x-1
        elseif love.keyboard.isDown("right") and self.pos.x < Game.dimensions.x-self.quadWidth then
            self.pos.x = self.pos.x+1
        end

        if love.keyboard.isDown("up") and self.pos.y > 0 then
            self.pos.y = self.pos.y-1
        elseif love.keyboard.isDown("down") and self.pos.y < Game.dimensions.y-self.quadHeight then
            self.pos.y = self.pos.y+1
        end

        if love.keyboard.isDown(" ") then
            local bullet = Bullet.new(self.pos, self:calcOffsetAngle(self.currentQuad))
            table.insert(self.bullets, bullet)
        end
    end

    for key,bullet in pairs(self.bullets) do
        bullet:update(dt)
    end
end

function Player:draw()
    love.graphics.draw(self.sprite, self.quads[self.currentQuad], self.pos.x, self.pos.y)
    for key,bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

return Player
