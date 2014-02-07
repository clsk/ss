Game = require "Game"
local Bullet = require "Bullet"

local ScoreBoard = {}
ScoreBoard.__index = ScoreBoard
ScoreBoard.deadEnemySound = love.audio.newSource("sounds/dead_enemy.mp3", "static")
ScoreBoard.hurtSound = love.audio.newSource("sounds/hurt.mp3", "static")
ScoreBoard.hellFireSound = love.audio.newSource("sounds/hellfire.mp3", "static")
function ScoreBoard.new(player, lives)
    local self = setmetatable({}, ScoreBoard)

    self.lives = lives
    self.points = 0
    self.hellFires = 3
    self.player = player
    return self
end

function ScoreBoard:draw()
    -- Print Lives
    love.graphics.draw(self.player.sprite, self.player.quads[0], Game.dimensions.x-32, 9, 0, .75, .75)
    love.graphics.print(self.lives, Game.dimensions.x-46, 10)

    -- Print Points
    love.graphics.print("Points: "..self.points, (Game.dimensions.x/2)-32, 10)

    -- Print HellFires
    love.graphics.draw(Bullet.weaponsImage, Bullet.weaponsQuads["hellFire"], 32, 0, math.pi/2, 1.25, 1.25)
    love.graphics.print(self.hellFires, 32, 10)

end

function ScoreBoard:takeLife()
    self.lives = self.lives - 1
    love.audio.play(self.hurtSound)
end

function ScoreBoard:givePoint()
    self.points = self.points+1
    love.audio.play(self.deadEnemySound)
    if self.points == 50 then
        Game.scene.enemyInterval = 0
    end
end

function ScoreBoard:takeHellFire()
    self.hellFires = self.hellFires-1
    love.audio.play(self.hellFireSound)
end

return ScoreBoard;
