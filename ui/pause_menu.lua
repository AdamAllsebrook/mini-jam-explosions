Pause = Menu:extend()

function Pause:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    local size = self.buttonSize
    self.texts = {
        Menu.Text('paused', Vector(dims.x / 2, 40), fonts.mid, nil, true)
    }
    self.buttons = {
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 80), size, 'RESUME', function () gamestate = level end),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 110), size, 'RESTART', function () gamestate = level ; level.restart = true end),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 140), size, 'LEVEL SELECT', function () gamestate = LevelSelect() end),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 170), size, 'MENU', function () gamestate = MainMenu() end),
    }
end

function Pause:update(dt)
    self.super.update(self, dt)
end

function Pause:draw()
    self.super.draw(self)
end

return Pause