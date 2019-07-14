Bomb = Object:extend()

local Explosion = require('objects.explosion')

Bomb.image = love.graphics.newImage('gfx/bomb.png')

function Bomb:new(pos)
    self.pos = pos * tileSize
    self.size = Vector(7, 9)
    self.vel = Vector(0, 0)
    self.accel = Vector(0, 1000)
    world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
    self.rigid = true
    self.isJumpable = true
    self.isGrabbable = true
    self.isExplodable = true
    self.bounciness = .3

    self.friction = .7
    self.minVel = 1
    self.jumpVel = Vector(100, -100)

    self.held = false

    self.explodeAt = 5
    self.timer = 0
end

function Bomb:explode()
    if not world:hasItem(self) then
        level.player:removeItem()
    end
    local pos = Vector(self.pos.x + self.size.x / 2, math.ceil(self.pos.y) + self.size.y / 2)
    world:remove(self)
    level:remove(self)
    level:add(Explosion(pos))
end

function Bomb:pickUp(pos)
    world:remove(self)
    self.pos = pos
    self.held = true
end

function Bomb:drop()
    self.held = false
    world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Bomb:moveTo(pos)
    self.pos = pos
end

function Bomb:jumpedOn(other)
    if other.pos.x + other.size.x / 2 < self.pos.x + self.size.x / 2 then
        self.vel = Vector(self.jumpVel:unpack())
    else
        self.vel = Vector(self.jumpVel.x * -1, self.jumpVel.y)
    end
end

function Bomb:isOnFloor()
    local cols, len = world:queryRect(self.pos.x, self.pos.y + self.size.y + .5, self.size.x, 1)
    for i = 1, len do
        if cols[i].solid then
            return true
        end
    end
end

function Bomb:changeVelocityByCollisionNormal(nx, ny)
    local vx, vy = self.vel:unpack()
  
    if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
      vx = -vx * self.bounciness
    end
  
    if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
      vy = -vy * self.bounciness
    end
  
    self.vel = Vector(vx, vy)
end

function Bomb:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.explodeAt then
        self:explode()
        return 
    end

    if not self.held then
        if self:isOnFloor() then
            self.vel.x = self.vel.x * self.friction
        end

        if math.abs(self.vel.x) < self.minVel then
            self.vel.x = 0
        end

        self.vel = self.vel + self.accel * dt
        local lastPos = Vector(self.pos:unpack())
        self.pos = self.pos + self.vel * dt

        local actualX, actualY, cols, len = world:move(self, self.pos.x, self.pos.y, filter)
        for i = 1, len do
            if cols[i].type == 'bounce' then
                if cols[i].normal.y ~= 0 and cols[i].other.moveThrough and (self.vel.y <= 0 or lastPos.y + self.size.y > cols[i].other.pos.y) then
                    actualX, actualY = self.pos.x, self.pos.y
                else
                    self:changeVelocityByCollisionNormal(cols[i].normal.x, cols[i].normal.y)
                end
            end
            if cols[i].other.isSwitch then
                cols[i].other.other:doSwitch(self)
            end
        end
        self.pos = Vector(actualX, actualY)
        world:update(self, self.pos.x, self.pos.y)
    end
    local items, len = world:queryRect(self.pos.x, self.pos.y, self.size.x, self.size.y)
    for i = 1, len do
        if items[i].forceExplode then
            self:explode()
        end
    end
end

function Bomb:draw()
    shaders.flash:send('time', self.timer)
    love.graphics.setShader(shaders.flash)
    love.graphics.draw(self.image, self.pos.x, math.ceil(self.pos.y))
    love.graphics.setShader()
    --love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.size.x, self.size.y)
end

return Bomb