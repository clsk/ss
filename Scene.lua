local Enemy = require "Enemy"

local Scene = {}
Scene.__index = Scene
function Scene.new(background_image, player, lives)
    local self = setmetatable({}, Scene)
    self.background_image = background_image
    self.player = player
    self.enemies = {}
    self.lastEnemy = os.time() - 3
    self.lives = lives or 5
    return self
end

function Scene:update(dt)
    for key, enemy in pairs(self.enemies) do
        if not enemy:update(dt) then
            self:removeEnemy(key)
        end
    end

    self.player:update(dt)

    if os.time() - self.lastEnemy > 5 then
        table.insert(self.enemies, Enemy.new(self.player.pos))
        print("creating enemy")
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
    print("took 1 life")
    self.lives = self.lives - 1
    if self.lives < 1 then
        --Game over
    end
end

return Scene
