Game = require "Game"
local ScoreBoard = {}
ScoreBoard.__index = ScoreBoard
function ScoreBoard.new(player, lives)
    local self = setmetatable({}, ScoreBoard)

    self.lives = lives
    self.points = 0
    self.player = player
    return self
end

function ScoreBoard:draw()
    love.graphics.draw(self.player.sprite, self.player.quads[0], Game.dimensions.x-32, 1, 0, .75, .75)
    love.graphics.print(self.lives, Game.dimensions.x-46, 1)

    love.graphics.print("Points: "..self.points, (Game.dimensions.x/2)-32, 1)
end

function ScoreBoard:takeLife()
    self.lives = self.lives - 1

    if self.lives < 1 then
        return false
    else
        return true
    end
end

function ScoreBoard:givePoint()
    self.points = self.points+1
end

function ScoreBoard:takePoint()
    self.points = self.points - 1
end

return ScoreBoard;
