Spikes = Object:extend()

local image = love.graphics.newImage('gfx/spikes.png')

function Spikes:new(pos)
    self.pos = pos * tileSize
    self.size = Vector(16, 3)
    self.rectOffset = Vector(0, 13)
    world:add(self, self.pos.x + self.rectOffset.x, self.pos.y + self.rectOffset.y, self.size.x, self.size.y)
    self.solid = true
    self.spiky = true
end

function Spikes:explode()
    world:remove(self)
    level:remove(self)
    level:add(Debris(self.pos + Vector(tileSize, tileSize) / 2))
end

function Spikes:update(dt)
end

function Spikes:draw()
    love.graphics.draw(image, self.pos.x, self.pos.y)
end

return Spikes