local Button = Object:extend()

local NineSlice = require('ui.9slice')

local ss = Spritesheet(love.graphics.newImage('gfx/button.png'), 24)
local images = {
	up = NineSlice(ss:extractImage(0, 0), 8),
	rollover = NineSlice(ss:extractImage(1, 0), 8),
	down = NineSlice(ss:extractImage(2, 0), 8),
}

function Button:new(pos, size, text, func, font, shader)
	self.down = false
	self.rollover = false
	self.pos = pos
	self.size = size
	self.text = love.graphics.newText(font or fonts.small, text)
	self.textOffset = (size - Vector(self.text:getDimensions())) / 2 + Vector(0, -1)
	self.images = {
		up = images.up:getImage(self.size.x, self.size.y),
		rollover = images.rollover:getImage(self.size.x, self.size.y),
		down = images.down:getImage(self.size.x, self.size.y),
	}
	self.func = func or function () end
	self.shader = shader
end

function Button:update(dt)
	mousePos = getMousePos()
	if self.pos.x <= mousePos.x and mousePos.x <= self.pos.x + self.size.x and self.pos.y < mousePos.y and mousePos.y < self.pos.y + self.size.y then
		if love.mouse.isDown(1) then
			self.down = true
		elseif self.down then
			self.down = false
			self.func()
			sounds.click:play()
		else
			self.down = false
			self.rollover = true
		end
	else
		self.rollover = false
		self.down = false
	end
end

function Button:draw()
	local img
	local textOffset = Vector()
	if self.down then
		img = self.images.down
		textOffset.y = 1
	elseif self.rollover then
		img = self.images.rollover
	else
		img = self.images.up
	end
	love.graphics.setShader(self.shader)
	love.graphics.draw(img, self.pos.x, self.pos.y)
	love.graphics.draw(self.text, (self.pos + self.textOffset + textOffset):unpack())
	love.graphics.setShader()
end

return Button
