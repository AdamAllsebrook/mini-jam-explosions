Player = Object:extend()
Player.player = true

local ss = Spritesheet(love.graphics.newImage('gfx/player.png'), 16)

function Player:new(pos)
    self.pos = pos * tileSize
    self.vel = Vector(0, 0)
    self.accel = Vector(0, 1000)
    self.size = Vector(10, 14)
    self.imgOffset = Vector(-3, -2)
    world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
    self.kinematic = true

    self.friction = .7
    self.minSpeed = 1
    self.groundAccel = 350
    self.maxGroundSpeed = 120
    self.opposeDirectionMult = 4

    self.jumpVel = -240
    self.jumpHoldTime = 0.2
    self.jumpHoldTimer = 0
    self.jumpHoldThrust = -500
    self.jumpReleaseMult = .6
    self.isJumpHeld = false

    self.heldItem = nil
    self.handSize = Vector(7, 9)
    self.dropVel = Vector(250, 0)
    self.throwVel = Vector(350, -200)
    self.throwUpVel = Vector(0, -400)

    self.direction = 1

    self.anims = {
        idle = Anim(ss:getFrames(0, 0, 2), 6, true),
        run = Anim(ss:getFrames(2, 0, 4), 10, true),
        throw = Anim(ss:getFrames(7, 0, 3), 15, function ()
            self.anims.throw:reset()
            self.anim = self.anims.idle
        end),
    }
    self.anim = self.anims.idle
    self.image = ss:getImage(0, 0)

    self.sounds = {
        die = love.audio.newSource(sounds.die, 'static'),
        grab = love.audio.newSource(sounds.grab, 'static'),
        jump = love.audio.newSource(sounds.jump, 'static'),
        throw = love.audio.newSource(sounds.throw, 'static'),
    }
end

--actions

function Player:jump(mult)
    self.vel.y = self.jumpVel * (mult or 1)
    self.isJumpHeld = true
    self.jumpHoldTimer = 0
    self.sounds.jump:play()
end

function Player:drop()
    self.heldItem.vel = Vector(self.dropVel.x * self.direction, self.dropVel.y)
end

function Player:throw()
    self.heldItem.vel = Vector(self.throwVel.x * self.direction, self.throwVel.y)
    self.sounds.throw:play()
end

function Player:throwUp()
    self.heldItem.vel = Vector(self.throwUpVel.x * self.direction, self.throwUpVel.y)
    self.sounds.throw:play()
end

function Player:removeItem()
    self.heldItem:drop()
    self.heldItem = nil
end

function Player:explode()
    level.restart = true
    self.sounds.die:play()
end

-- physics

function Player:isOnFloor()
    local cols, len = world:queryRect(self.pos.x, self.pos.y + self.size.y, self.size.x, .5)
    for i = 1, len do
        if cols[i].solid then 
            return true
        end
    end
end

function Player:isOnFloorForJump()
    local cols, len = world:queryRect(self.pos.x - 0, self.pos.y + self.size.y, self.size.x + 0, .5)
    for i = 1, len do
        if cols[i].solid then 
            return true
        end
    end
end

function Player:isOnCeiling()
    local cols, len = world:queryRect(self.pos.x, self.pos.y - .5, self.size.x, .5)
    for i = 1, len do
        if cols[i].solid and not cols[i].moveThrough then 
            return true
        end
    end
end

function Player:getJumpable()
    local cols, len = world:queryRect(self.pos.x, self.pos.y + self.size.y + .5, self.size.x, 1)
    for i = 1, len do
        if cols[i].isJumpable then
            return cols[i]
        end
    end
end

function Player:getGrabbable()
    local cols, len = world:queryRect(self.pos.x + self.size.x / 2 + (self.handSize.x * (self.direction - 1) / 2), self.pos.y + self.size.y / 2, self.handSize.x, self.handSize.y)
        for i = 1, len do
        if cols[i].isGrabbable then
            return cols[i]
        end
    end
end

function Player:getGrabbablePos()
    local pos = self.pos + self.size / 2 + Vector(-3.5 + self.direction * 5.5, -2)
    if self.anim == self.anims.run or self.anim == self.anims.idle then
        if self.anim:getFrame() % 2 == 0 then
            pos.y = pos.y - 1
        end
    end
    return pos
end

function Player:update(dt)
    -- horizontal
    local x, y = input:get('move')
    if x == 0 then
        self.accel.x = 0
        self.vel.x = self.vel.x * self.friction
        if math.abs(self.vel.x) < self.minSpeed then
            self.vel.x = 0
        end
    elseif math.abs(x) > .5 then
        if lume.round(x) == lume.sign(self.vel.x) then
            self.accel.x = x * self.groundAccel
        else
            self.accel.x = x * self.groundAccel * self.opposeDirectionMult
        end
    end
    self.vel.x = lume.clamp(self.vel.x, -self.maxGroundSpeed, self.maxGroundSpeed)

    -- vertical
    local jumpable = self:getJumpable()
    if jumpable and self.vel.y > 0 and not self:isOnFloor() then
        jumpable:jumpedOn(self)
        if input:get('jump') then
            self:jump(1.2)
        else
            self:jump()
            self.isJumpHeld = false
            self.vel.y = self.vel.y * self.jumpReleaseMult
        end
    else
        if input:get('jump') == 1 then
            if self:isOnFloorForJump() and self.vel.y > 0 then
                self:jump()
            else
                if self:isOnCeiling() then
                    self.isJumpHeld = false
                    self.vel.y = 0
                end
                if self.isJumpHeld and self.jumpHoldTimer < self.jumpHoldTime then
                    self.vel.y = self.vel.y + self.jumpHoldThrust * dt
                    self.jumpHoldTimer = self.jumpHoldTimer + dt
                end
            end
        elseif input:released('jump') then
            self.vel.y = self.vel.y * self.jumpReleaseMult
            self.isJumpHeld = false
        else
            if self:isOnFloor() then
                self.vel.y = 0
            end
        end
    end

    self.vel = self.vel + self.accel * dt
    local lastPos = Vector(self.pos:unpack())
    self.pos = self.pos + self.vel * dt

    local actualX, actualY, cols, len = world:move(self, self.pos.x, self.pos.y, filter)
    for i = 1, len do
        if cols[i].normal.y ~= 0 and cols[i].other.moveThrough then 
            if self.vel.y <= 0 or lastPos.y + self.size.y > cols[i].other.pos.y then
             actualX, actualY = self.pos.x, self.pos.y
            end
        end
        if cols[i].other.isSwitch then
            cols[i].other.other:doSwitch(self)
        elseif cols[i].other.spiky then
            self:explode()
        end
    end
    self.pos = Vector(actualX, actualY)
    world:update(self, self.pos.x, self.pos.y)

    -- grab
    if input:get('grab') == 1 then    
        if self.heldItem then
            self.heldItem:moveTo(self:getGrabbablePos())
        else
            self.heldItem = self:getGrabbable()
            if self.heldItem then
                self.heldItem:pickUp(self:getGrabbablePos())
                self.sounds.grab:play()
            end
        end
    elseif self.heldItem then
        if input:get('down') == 1 then
            self:drop()
        elseif input:get('up') == 1 then
            self:throwUp()
        else
            self:throw()
        end
        self.anim = self.anims.throw
        self:removeItem()
    end

    --drawing
    if self.vel.x ~= 0 then
        self.direction = lume.sign(self.vel.x)
    end
    if self.anim ~= self.anims.throw then
        if self:isOnFloor() then
            if self.vel.x == 0 then
                self.anim = self.anims.idle
            else
                self.anim = self.anims.run
            end
        end
    end
    self.anim:update(dt)

    --death
    if self.pos.x < -32 or self.pos.x > (level.size.x + 2) * tileSize or self.pos.y < -32 or self.pos.y > 224 then
        self:explode()
    end
end

function Player:draw()
    love.graphics.push()
    love.graphics.translate(self.imgOffset.x * self.direction, self.imgOffset.y)
    love.graphics.translate(self.pos.x + self.size.x / 2, 0)
    love.graphics.scale(self.direction, 1)
    love.graphics.translate(-self.pos.x - self.size.x / 2, 0)
    love.graphics.draw(ss.image, self.anim:get(), self.pos.x, self.pos.y)
    love.graphics.pop()
    --love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.size.x, self.size.y)
    --local x, y = self.pos.x + self.size.x / 2 + (self.handSize.x * (self.direction - 1) / 2), self.pos.y + self.size.y / 2
    --love.graphics.rectangle('fill', x, y, self.handSize:unpack())
    if self.heldItem then
        self.heldItem:draw()
    end
end

return Player