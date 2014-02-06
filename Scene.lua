local Enemy = require "Enemy"
local Point = require "Point"
Game = require "Game"

local Scene = {}
Scene.__index = Scene
Scene.takeoffSound = love.audio.newSource("sounds/takeoff.mp3", "static")
-- background_image:love.graphics.image Scene Background Image
-- player:Player Scene player
-- lives:Integer Player initial lives
-- enemyInterval:Integer Interval between enemy creation
function Scene.new(background_image, player, lives, enemyInterval)
    local self = setmetatable({}, Scene)
    self.background_image = background_image
    self.player = player
    self.enemies = {}
    self.lastEnemy = os.time() - 3
    self.lives = lives or 5
    self.enemyInterval = enemyInterval or 3

    love.audio.play(Scene.takeoffSound)
    return self
end

function Scene:update(dt)
    for key, enemy in pairs(self.enemies) do
        if not enemy:update(dt) then
            self:removeEnemy(key)
        end
    end

    self.player:update(dt)

    if os.time() - self.lastEnemy > self.enemyInterval then
        table.insert(self.enemies, Enemy.new(Point.new(math.random(0, Game.dimensions.x-self.player.quadWidth), math.random(0, Game.dimensions.y/3))))
        self.lastEnemy = os.time()
    end
end

function Scene:draw()
    love.graphics.draw(self.background_image)
    self.player:draw()

    for key, enemy in pairs(self.enemies) do
        enemy:draw()
    end
end

function Scene:removeEnemy(key)
    table.remove(self.enemies, key)
end

function Scene:takeLife()
    self.lives = self.lives - 1
    if self.lives < 1 then
        --Game over
    end
end

return Scene
