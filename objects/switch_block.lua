SwitchBlock = Object:extend()

local ss = Spritesheet(love.graphics.newImage('gfx/switch_block.png'), 16)

function SwitchBlock:new(pos, type)
    self.pos = pos * tileSize
    self.size = Vector(tileSize, tileSize)
    self.solid = true

    self.type = type

    self.images = {
        [0] = {
            [0] = ss:getImage(1, 0),
            ss:getImage(0, 0)
        },
        {
            [0] = ss:getImage(2, 0),
            ss:getImage(3, 0),
        }
    }
end

function SwitchBlock:explode()
    if world:hasItem(self) then
        world:remove(self)
    end
    level:remove(self)
end

function SwitchBlock:update(dt)
    if level.switch ~= self.type and world:hasItem(self) then
        world:remove(self)
    elseif level.switch == self.type and not world:hasItem(self) then
        world:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
    end
end

function SwitchBlock:draw()
    love.graphics.draw(ss.image, self.images[self.type][level.switch], self.pos.x, self.pos.y)
end

return SwitchBlock