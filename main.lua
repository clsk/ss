Game = require "Game"
local Player = require "Player"
local Scene = require "Scene"

function love.load()
    love.window.setMode(Game.dimensions.x, Game.dimensions.y)
    Game.scene = Scene.new(love.graphics.newImage('images/background.png'), Player.new(love.graphics.newImage('images/ship_32.png')))
end

function love.draw()
    Game.scene:draw()
end

function love.update(dt)
    Game.scene:update(dt)
end

