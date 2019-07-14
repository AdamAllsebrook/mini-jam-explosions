Text = Object:extend()

function Text:new(text, pos, font, col, shadow)
    self.text = love.graphics.newText(font or fonts.small, text)
    self.pos = pos - Vector(self.text:getDimensions()) / 2
    self.col = col or {1, 1, 1}
    self.shadow = shadow
end

function Text:update(dt)
end

function Text:draw()
    if self.shadow then
        love.graphics.setColor(0, 0, 0)
        love.graphics.draw(self.text, self.pos.x, self.pos.y + 2)
    end
    love.graphics.setColor(self.col)
    love.graphics.draw(self.text, self.pos.x, self.pos.y)
    love.graphics.setColor(1, 1, 1)
end

return Text