local Scene = {}
Scene.__index = Scene
function Scene.new(background_image)
    local self = setmetatable({}, Scene)
    self.background_image = background_image
    self.players = {}
    return self
end

function Scene:addPlayer(player)
    print(player)
    if (player ~= nil) then
        table.insert(self.players, player)
    end
    print(table.getn(self.players))
end

function Scene:update(dt)
    for key,player in pairs(self.players) do
        self.players[key]:update(dt)
    end
end

function Scene:draw()
    love.graphics.draw(self.background_image)
    for key,player in pairs(self.players) do
        player:draw()
    end
end

return Scene
