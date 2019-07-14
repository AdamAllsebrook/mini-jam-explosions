Select = Menu:extend()

local maxLevel = 24
local width = 6

function Select:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    self.buttons = {
        Menu.Button(Vector(dims.x / 2 - 30, dims.y - 28), Vector(60, 25), 'RETURN', function () gamestate = MainMenu() end)
    }
    local offset = Vector((dims.x - width * 44) / 2, 27)
    for i = 1, maxLevel do
        local x = (i - 1) % width
        local y = (i - x) / width
        local func, shader = function () gamestate = Level(i) end
        if i > unlocked then 
            shader = shaders.greyscale
            func = function () end
        end
        self.buttons[#self.buttons + 1] = Menu.Button(Vector(x * 44 + offset.x, y * 28 + offset.y), Vector(40, 24), pad(i, 2), func, nil, shader)
    end
    self.texts = {
        Menu.Text('LEVEL SELECT', Vector(dims.x / 2, 12), fonts.mid, nil, true),
    }
end

function Select:update(dt)
    self.super.update(self, dt)
end

function Select:draw()
    self.super.draw(self)
end

return Select