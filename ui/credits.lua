Credits = Menu:extend()

function Credits:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    local size = Vector(150, 25)
    self.texts = {
        Menu.Text('credits', Vector(dims.x / 2, 40), fonts.mid, nil, true)
    }
    self.buttons = {
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 70), size, 'music - Joshua McLean', function () love.system.openURL('http://mrjoshuamclean.com/royalty-free-music/') end),
        Menu.Button(Vector(dims.x / 2 - size.x / 2, 100), size, 'font - BitPotion', function () love.system.openURL('https://joebrogers.itch.io/bitpotion') end),
        Menu.Button(Vector(dims.x / 2 - self.buttonSize.x / 2, 130), self.buttonSize, 'RETURN', function () gamestate = MainMenu() end)
    }
end

function Credits:update(dt)
    self.super.update(self, dt)
end

function Credits:draw()
    self.super.draw(self)
end

return Credits