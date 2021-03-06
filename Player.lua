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
    self.pos = pos or Point.new(Game.dimensions.x/2, Game.dimensions.y*0.75)
    self.bullets = {}
    self.lastShot = os.time() - 1
    -- Initialization
    self.createQuads(self)
    self.quadCount = table.getn(self.quads)+1
    self.currentQuad = 0
    self.RADIAN_OFFSET = (2*math.pi) / (self.quadCount)

    return self
end

Player.singleShotSound = love.audio.newSource("sounds/single_shot.mp3", "static")

function Player:createQuads()
    for y = 0, self.height-self.quadHeight, self.quadHeight do
        for x = 0, self.width-self.quadWidth, self.quadWidth do
            table.insert(self.quads, ((y/self.quadHeight)*6) + (x/self.quadWidth), love.graphics.newQuad(x, y, self.quadWidth, self.quadHeight, self.width, self.height))
        end
    end
end

-- at self.quadCount/4 player is facing right, thus at 0 degrees
function Player:calcOffsetAngle(currentQuad)
    return self.RADIAN_OFFSET*(self.quadCount) - (self.RADIAN_OFFSET*(currentQuad - (self.quadCount/4)))
end

function Player:update(dt)
    if love.keyboard.isDown("lshift") then
        if love.keyboard.isDown("right") then
            if (self.currentQuad == (self.quadCount-1)) then
                self.currentQuad = 0
            else
                self.currentQuad = self.currentQuad+1
            end
        elseif love.keyboard.isDown("left") then
            if (self.currentQuad == 0) then
                self.currentQuad = (self.quadCount-1)
            else
                self.currentQuad = self.currentQuad-1
            end
        elseif love.keyboard.isDown("g") then
            if Game.scene.scoreBoard.hellFires > 0 and (os.time() - self.lastShot) > 0 then
                for i = 0, 72, 1 do
                    table.insert(self.bullets, Bullet.new(self.pos, self:calcOffsetAngle(i)))
                end
                Game.scene.scoreBoard:takeHellFire()
                self.lastShot = os.time()
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

        if love.keyboard.isDown(" ") and (os.time() - self.lastShot) > 0 then
            local bullet = Bullet.new(self.pos, self:calcOffsetAngle(self.currentQuad))
            table.insert(self.bullets, bullet)
            love.audio.play(Player.singleShotSound)
            self.lastShot = os.time()
        end
    end

    for key,bullet in pairs(self.bullets) do
        if not bullet:update(dt) then
            table.remove(self.bullets, key)
        end
    end
end

function Player:draw()
    love.graphics.draw(self.sprite, self.quads[self.currentQuad], self.pos.x, self.pos.y)
    for key,bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

return Player
