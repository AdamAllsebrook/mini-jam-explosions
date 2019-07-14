ExplosiveBlock = Object:extend()

local Explosion = require('objects.explosion')

local ss = Spritesheet(love.graphics.newImage('gfx/explosive_block.png'), 16)

function ExplosiveBlock:new(pos)
    self.pos = pos * tileSize
    self.size = Vector(tileSize, tileSize)
    world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
    self.solid = true

    self.image = ss:getImage(0, 0)
end

function ExplosiveBlock:explode()
    if world:hasItem(self) then
        world:remove(self)
    end
    level:remove(self)
    level:add(Explosion(self.pos + self.size / 2))
end

function ExplosiveBlock:update(dt) 
end

function ExplosiveBlock:draw()
    love.graphics.draw(ss.image, self.image, self.pos.x, self.pos.y)
end

return ExplosiveBlock