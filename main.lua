local Scene = require "Scene"
local Player = require "Player"

mainScene = Scene.new(love.graphics.newImage('images/background.png'))

function love.load()
    love.window.setMode(640,480)
    mainScene:addPlayer(Player.new(love.graphics.newImage('images/ship_32.png')))
end

function love.draw()
    mainScene:draw()
end

function love.update(dt)
    mainScene:update(dt)
end

