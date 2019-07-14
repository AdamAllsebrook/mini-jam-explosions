local ss = Object:extend()

function ss:new(image, w, h)
	self.image = image
	self.w = w
	self.h = h or w
end

function ss:getImage(x, y, w, h)
	w = w or 1
	h = h or 1
	return love.graphics.newQuad(x * self.w, y * self.h, w * self.w, h * self.h, self.image:getDimensions())
end

function ss:extractImage(x, y)
	local c = love.graphics.newCanvas(self.w, self.h)
	love.graphics.setCanvas(c)
	love.graphics.push()
	love.graphics.origin()
	love.graphics.draw(self.image, self:getImage(x, y))
	love.graphics.pop()
	love.graphics.setCanvas()
	return c
end

function ss:getFrames(x, y, num)
	local images = {}
	for i = 0, num - 1 do
		images[i + 1] = self:getImage(x + i, y)
	end
	return images
end

return ss
