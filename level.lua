Level = Object:extend()

local Player = require('player')

local Block = require('objects.block')
local Bomb = require('objects.bomb')
local Platform = require('objects.platform')
local Laser = require('objects.laser')
local Switch = require('objects.switch')
local SwitchBlock = require('objects.switch_block')
local ExplosiveBlock = require('objects.explosive_block')
local Gem = require('objects.gem')

local background = love.graphics.newImage('gfx/background.png')

function Level:new(num)
    self.num = num
    level = self
    world = bump.newWorld(tileSize)
    --[[
    local list = require('levels/' .. pad(num, 3))
    self.objs = {}
    for i, obj in ipairs(list) do
        if obj.block then
            self.objs[i] = Block(Vector(obj[1], obj[2]), Vector(obj[3], obj[4]))
        elseif obj.bomb then
            self.objs[i] = Bomb(Vector(obj[1], obj[2]))
        end
    end
    --]]
    local str = require('levels/' .. pad(num, 3))
    local i = str:find('\n')
    local dims = str:sub(1, i - 1)
    local level = str:sub(i + 1, -1)
    level = level:gsub('\n', '')
    i = dims:find('x')
    dims = Vector(tonumber(dims:sub(1, i - 1)), tonumber(dims:sub(i + 1, -1)))
    local playerStart = Vector()

    self.objs = {}
    for x = 1, dims.x do
        for y = 1, dims.y do
            local i, obj = x + dims.x * (y - 1)
            local char = level:sub(i, i)
            if char == 'q' then
                obj = Block(Vector(x, y), Vector(1, 1))
            elseif char == 'w' then
                    obj = Block(Vector(x, y), Vector(2, 1))
            elseif char == 'a' then
                obj = Block(Vector(x, y), Vector(1, 2))
            elseif char == 's' then
                obj = Block(Vector(x, y), Vector(2, 2))
            elseif char == 'b' then
                obj = Bomb(Vector(x, y))
            elseif char == 'e' then
                obj = Platform(Vector(x, y), 0)
            elseif char == 'r' then
                obj = Platform(Vector(x, y), 1)
            elseif char == 'p' then
                playerStart = Vector(x, y)
            elseif char == 'l' then
                obj = Laser(Vector(x, y))
            elseif char == 'f' then
                obj = Switch(Vector(x, y))
            elseif char == 'g' then
                obj = SwitchBlock(Vector(x, y), 0)
            elseif char == 'h' then
                obj = SwitchBlock(Vector(x, y), 1)
            elseif char == 'u' then
                obj = ExplosiveBlock(Vector(x, y))
            elseif char == 'j' then
                obj = Gem(Vector(x, y))
            end
            self:add(obj)
        end
    end

    self.player = Player(playerStart)
    self.switch = 1
    self.started = false
    local dims = Vector(love.graphics.getDimensions()) / scale
    self.startText = Menu.Text('press jump to start', Vector(dims.x / 2, 50), fonts.mid, nil, true)
end

function Level:add(obj)
    self.objs[#self.objs + 1] = obj
end

function Level:remove(obj)
    local i = lume.find(self.objs, obj)
    table.remove(self.objs, i)
end

function Level:update(dt)
    if self.started then
        for _, obj in ipairs(self.objs) do
            obj:update(dt)
        end
        self.player:update(dt)
        if input:pressed('pause') then
            gamestate = PauseMenu()
        end
    else
        if input:released('jump') then
            self.started = true
        end
    end
    if self.restart then
        gamestate = Level(self.num)
    end
end

function Level:finish()
    gamestate = LevelEnd()
    unlocked = unlocked + 1
end

function Level:draw()
    local dims = Vector(love.graphics.getDimensions()) / scale
    love.graphics.push()
        love.graphics.draw(background, -50, -50)
        local dx = math.min(dims.x / 2 - self.player.pos.x, -16)
        local dy = math.max(dims.y / 2 - self.player.pos.y, -16)
        love.graphics.translate(dx, dy)
        for _, obj in ipairs(self.objs) do
            obj:draw()
        end
        self.player:draw()
    love.graphics.pop()
    if not self.started then
        love.graphics.setColor(0, 0, 0, .5)
        love.graphics.rectangle('fill', 0, 0, dims.x, dims.y)
        love.graphics.setColor(1, 1, 1)
        self.startText:draw()
    end
end

return Level