Gem = Object:extend()

local image = love.graphics.newImage('gfx/gem.png')

function Gem:new(pos)
    self.pos = pos * tileSize
    self.size = Vector(16, 11)
    self.rectOffset = Vector(0, 3)
    self.timer = 0
    self.yOffset = 0
end

function Gem:update(dt)
    self.timer = (self.timer + 5 * dt) % (2 * math.pi)
    self.yOffset = 1.5 * math.sin(self.timer)

    local items, len = world:queryRect(self.pos.x + self.rectOffset.x, self.pos.y + self.rectOffset.y + self.yOffset, self.size.x, self.size.y)
    for i = 1, len do
        if items[i].player then
            level:finish()
        end
    end
end

function Gem:draw()
    love.graphics.draw(image, self.pos.x, self.pos.y + self.yOffset)
    --love.graphics.rectangle('fill', self.pos.x + self.rectOffset.x, self.pos.y + self.rectOffset.y + self.yOffset, self.size.x, self.size.y)
end

return Gem