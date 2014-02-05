local Point = require "Point"
local Scene = require "Scene"

Game = {
    ["scene"] = Scene.new(love.graphics.newImage('images/background.png')),
    ["dimensions"] = Point.new(640, 480)
}


return Game;
