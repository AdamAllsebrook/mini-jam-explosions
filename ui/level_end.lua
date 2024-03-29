LevelEnd = Menu:extend()

function LevelEnd:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    self.texts = {
        Menu.Text('level completed!', Vector(dims.x / 2, 50), fonts.mid, nil, true)
    }
    local size = self.buttonSize
    self.buttons = {
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 90), size, 'NEXT LEVEL', function () gamestate = Level(level.num + 1) end),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 120), size, 'LEVEL SELECT', function () gamestate = LevelSelect() end),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 150), size, 'MENU', function () gamestate = MainMenu() end),
    }
    self.skipOnJump = false
end

function LevelEnd:update(dt)
    self.super.update(self, dt)
    if input:released('jump') and self.skipOnJump then
        gamestate = Level(level.num + 1)
    end
    if input:get('jump') == 0 then
        self.skipOnJump = true
    end
end

function LevelEnd:draw()
    self.super.draw(self)
end

return LevelEnd