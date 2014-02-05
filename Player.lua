local Player = {}
Player.__index = Player
function Player.new(sprite)
    local self = setmetatable({}, Player)
    self.sprite = sprite
    self.quads = {}
    self.createQuads(self)
    return self
end

function Player:createQuads(sprite)
    width, height = self.sprite:getDimensions()
    quadWidth = width / 6
    quadHeight = height / 12
    for y = 0, height-quadHeight, quadHeight do
        for x = 0, width-quadWidth, quadWidth do
            table.insert(self.quads, ((y/quadHeight)*6) + (x/quadWidth), love.graphics.newQuad(x, y, quadWidth, quadHeight, width, height))
        end
    end
end

function Player:update(dt)
end

function Player:draw()
    love.graphics.draw(self.sprite, self.quads[0], 10, 10)
end

return Player
