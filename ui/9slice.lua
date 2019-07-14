local NineSlice = Object:extend()

function NineSlice:new(image, size)
    self.image = image
    self.size = size
    self.images = {{}, {}, {}}
    for x = 0, 2 do
        for y = 0, 2 do
            self.images[x + 1][y + 1] = love.graphics.newQuad(x * size, y * size, size, size, image:getDimensions())
        end
    end
end

function NineSlice:getImage(w, h)
    love.graphics.push()
    love.graphics.origin()
    local c = love.graphics.newCanvas(w, h)
    love.graphics.setCanvas(c)

    for x = 1, math.ceil(w / self.size) - 2 do
        for y = 1, math.ceil(h / self.size) - 2 do
            love.graphics.draw(self.image, self.images[2][2], x * self.size, y * self.size)
        end
    end

    for x = 1, math.ceil(w / self.size) - 2 do
        love.graphics.draw(self.image, self.images[2][1], x * self.size, 0)
        love.graphics.draw(self.image, self.images[2][3], x * self.size, h - self.size)
    end
    for y = 1, math.ceil(h / self.size) - 2 do
        love.graphics.draw(self.image, self.images[1][2], 0, y * self.size)
        love.graphics.draw(self.image, self.images[3][2], w - self.size, y * self.size)
    end

    love.graphics.draw(self.image, self.images[1][1], 0, 0)
    love.graphics.draw(self.image, self.images[1][3], 0, h - self.size)
    love.graphics.draw(self.image, self.images[3][1], w - self.size, 0)
    love.graphics.draw(self.image, self.images[3][3], w - self.size, h - self.size)
    love.graphics.setCanvas()
    love.graphics.pop()
    return c
end

return NineSlice
