MainMenu = Menu:extend()

function MainMenu:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    self.texts = {
        Menu.Text('5 SECOND FUSE', Vector(dims.x / 2, 40), fonts.mid, nil, true)
    }
    local size = self.buttonSize
    self.buttons = {
        --pos, size, text, func
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 70), size, 'START', function () gamestate = LevelSelect() end),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 100), size, 'credits', function () gamestate = Credits() end),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 130), size, 'QUIT', love.event.quit),
        Menu.Button(Vector(dims.x / 2 - size.x - 10 - size.x / 2, dims.y - 30), size, self.getFullscreen(), self.toggleFullscreen),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, dims.y - 30), size, 'sound ' .. self.getSound(), self.toggleSound),
        Menu.Button(Vector(dims.x / 2 + size.x + 10 - size.x / 2, dims.y - 30), size, 'music ' .. self.getMusic(), self.toggleMusic),
    }
end

function MainMenu:update(dt)
    self.super.update(self, dt)
end

function MainMenu:draw()
    self.super.draw(self)
end

return MainMenu