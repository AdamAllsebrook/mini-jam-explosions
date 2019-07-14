Explosion = Object:extend()

local ss = Spritesheet(love.graphics.newImage('gfx/explosion.png'), 32)
local size = Vector(32, 32)

function Explosion:new(pos)
    self.pos = pos
    self.size = size
    self.anim = Anim(ss:getFrames(0, 0, 9), 12, function ()
        level:remove(self)
    end)
    self.exploded = false
    love.audio.newSource(sounds.explode, 'static'):play()
    screenShake:start(.2, 2)
end

function Explosion:update(dt)
    self.anim:update(dt)
    if not self.exploded and self.anim:getFrame() == 2 then
        local pos = Vector(self.pos.x  - self.size.x / 2, self.pos.y - self.size.y / 2)
        local items, len = world:queryRect(pos.x, pos.y, self.size.x, self.size.y)
        for i = 1, len do
            if items[i].explode then
                items[i]:explode()
            end
        end
        self.exploded = true
    end
end

function Explosion:draw()
    love.graphics.draw(ss.image, self.anim:get(), (self.pos - size / 2):unpack())
end

return Explosion