Switch = Object:extend()

local ss = Spritesheet(love.graphics.newImage('gfx/switch.png'), 16)

function Switch:new(pos)
    self.pos = pos * tileSize
    self.size = Vector(tileSize, tileSize)
    world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
    self.solid = true
    self.switchRect = {pos=Vector(self.pos.x + 2, self.pos.y + self.size.y - 2), size=Vector(self.size.x - 4, 2), isSwitch=true, other=self}
    world:add(self.switchRect, self.switchRect.pos.x, self.switchRect.pos.y, self.switchRect.size.x, self.switchRect.size.y)

    self.images = {[0]=ss:getImage(0, 0), ss:getImage(1, 0)}

    self.timers = {}
end

function Switch:doSwitch(other)
    if not (self.timers[other] and self.timers[other] > 0) then
        level.switch = 1 - level.switch 
        self.timers[other] = .1
    end
end

function Switch:update(dt)
    for i, time in pairs(self.timers) do
        if self.timers[i] > 0 then
            self.timers[i] = time - dt
        end
    end
end

function Switch:draw()
    love.graphics.draw(ss.image, self.images[level.switch], self.pos.x, self.pos.y)
end

return Switch