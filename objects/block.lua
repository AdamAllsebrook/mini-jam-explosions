Block = Object:extend()

local Debris = require('objects.debris')

local ss = Spritesheet(love.graphics.newImage('gfx/blocks.png'), 16, 16)

local imgs = {
    [3] = {x=0, y=0},
    [4] = {x=0, y=1},
    [5] = {x=1, y=0},
    [6] = {x=1, y=1},
}

function Block:new(pos, size)
    self.pos = pos * tileSize
    self.size = size * tileSize
    world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
    local imgPos = imgs[2 * size.x + size.y]
    self.solid = true

    self.image = ss:getImage(imgPos.x, imgPos.y, size.x, size.y)
end

function Block:explode()
    world:remove(self)
    level:remove(self)
    for x = 1, self.size.x / tileSize do
        for y = 1, self.size.y / tileSize do
            level:add(Debris(self.pos + Vector(tileSize, tileSize) / 2 + Vector(tileSize * (x - 1), tileSize * (y - 1))))
        end
    end
end

function Block:update(dt)
    return
end

function Block:draw()
    love.graphics.draw(ss.image, self.image, self.pos.x, self.pos.y)
end

return Block