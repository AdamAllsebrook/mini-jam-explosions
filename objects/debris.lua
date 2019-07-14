Debris = Object:extend()

local ss = Spritesheet(love.graphics.newImage('gfx/debris.png'), 32)
local size = Vector(16, 16)

function Debris:new(pos)
    self.pos = pos - size
    self.anim = Anim(ss:getFrames(0, 0, 7), 12, function ()
        level:remove(self)
    end)
    screenShake:start(.2, 1.5)
end

function Debris:update(dt)
    self.anim:update(dt)
end

function Debris:draw()
    love.graphics.draw(ss.image, self.anim:get(), self.pos.x, self.pos.y)
end

return Debris