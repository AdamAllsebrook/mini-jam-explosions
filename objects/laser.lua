Laser = Object:extend()

local ss = Spritesheet(love.graphics.newImage('gfx/laser.png'), 16)

function Laser:new(pos)
    self.pos = pos * tileSize
    self.image = ss:getImage(0, 1)
    self.size = Vector(4, self:getLaser())
    self.rectOffsetX = 6
    world:add(self, self.pos.x + self.rectOffsetX, self.pos.y, self.size.x, self.size.y)
    self.forceExplode = true

    self.anim = Anim(ss:getFrames(0, 0, 4), 16, true)

end

function Laser:getLaser()
    local y = self.pos.y
    for i = 1, 50 do
        y = y + tileSize
        local cols, len = world:queryRect(self.pos.x, y, tileSize, tileSize)
        for i = 1, len do
            if cols[i].solid then
                return y - tileSize - self.pos.y
            end
        end
    end
    return y - self.pos.y
end

function Laser:update(dt)
    if world:hasItem(self) then
        world:remove(self)
    end
    self.size.y = self:getLaser() + tileSize
    if level.switch == 1 then
        world:add(self, self.pos.x + self.rectOffsetX, self.pos.y, self.size.x, self.size.y)
    end

    self.anim:update(dt)
end

function Laser:draw()
    if level.switch == 1 then
        for y = self.pos.y, self.pos.y + self.size.y, tileSize do
            love.graphics.draw(ss.image, self.anim:get(), self.pos.x, y)
        end
    end
    --love.graphics.rectangle('fill', self.pos.x + self.rectOffsetX, self.pos.y, self.size.x, self.size.y)
    love.graphics.draw(ss.image, self.image, self.pos.x, self.pos.y)
end

return Laser