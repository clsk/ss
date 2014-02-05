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
    self.currentQuad = 0
    self.RADIAN_OFFSET = 0.0827
    self.ANGLE_OFFSET = 4.74
    self.currentRadianOffset = 3.14/2
    self.currentAngleOffset = 90
    self.pos = pos or Point.new(100,100)
    self.bullets = {}
    -- Initialization
    self.createQuads(self)
    
    return self
end

function Player:createQuads()
    for y = 0, self.height-self.quadHeight, self.quadHeight do
        for x = 0, self.width-self.quadWidth, self.quadWidth do
            table.insert(self.quads, ((y/self.quadHeight)*6) + (x/self.quadWidth), love.graphics.newQuad(x, y, self.quadWidth, self.quadHeight, self.width, self.height))
        end
    end
end

function Player:update(dt)
    if love.keyboard.isDown("lshift") then
        if love.keyboard.isDown("right") then
            if (self.currentQuad == 71) then
                self.currentQuad = 0
                self.radianOffset = 0
                self.currentAngleOffset = 0
            else
                self.currentQuad = self.currentQuad+1
                self.currentRadianOffset = self.currentRadianOffset + self.RADIAN_OFFSET
                self.currentAngleOffset = self.currentAngleOffset + self.ANGLE_OFFSET

            end
        elseif love.keyboard.isDown("left") then
            if (self.currentQuad == 0) then
                self.currentQuad = 71
                self.currentRadianOffset = self.RADIAN_OFFSET * (table.getn(self.quads)+1)
                self.currentAngleOffset = self.ANGLE_OFFSET * (table.getn(self.quads)+1)
            else
                self.currentQuad = self.currentQuad-1
                self.currentRadianOffset = self.currentRadianOffset - self.RADIAN_OFFSET
                self.currentAngleOffset = self.currentAngleOffset - self.ANGLE_OFFSET

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
            local bullet = Bullet.new(self.pos, self.currentRadianOffset)
            table.insert(self.bullets, bullet)
        end
    end

    for key,bullet in pairs(self.bullets) do
        bullet:update(dt)
    end

    print(self.currentRadianOffset)
    print(self.currentAngleOffset)
end

function Player:draw()
    love.graphics.draw(self.sprite, self.quads[self.currentQuad], self.pos.x, self.pos.y)
    for key,bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

return Player
