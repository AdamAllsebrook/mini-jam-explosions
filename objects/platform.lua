Platform = Object:extend()

local ss = Spritesheet(love.graphics.newImage('gfx/platform.png'), 16, 6)

function Platform:new(pos, img)
    self.pos = pos * tileSize
    self.size = Vector(16, 6)
    world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)

    self.solid = true
    self.moveThrough = true

    self.image = ss:getImage(img, 0)
end

function Platform:explode()
    world:remove(self)
    level:remove(self)
end

function Platform:update(dt)
    
end

function Platform:draw()
    love.graphics.draw(ss.image, self.image, self.pos.x, self.pos.y)
end

return Platform