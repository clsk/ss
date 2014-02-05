Game = require "Game"
local Player = require "Player"


function love.load()
    love.window.setMode(Game.dimensions.x, Game.dimensions.y)
    Game.scene:addPlayer(Player.new(love.graphics.newImage('images/ship_32.png')))
end

function love.draw()
    Game.scene:draw()
end

function love.update(dt)
    Game.scene:update(dt)
end

