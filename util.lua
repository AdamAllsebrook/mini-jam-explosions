function pad(number, zeroes)
	number = tostring(number)
	while #number < zeroes do
		number = "0" .. number
	end
	return number
end

function getMousePos()
	return Vector(love.mouse.getPosition()) / scale
end

screenShake = {}
screenShake.t, screenShake.dur, screenShake.mag = 0, -1, 0

function screenShake:start(dur, mag)
	if mag >= self.mag or self.t >= self.dur then
		self.t, self.dur, self.mag = 0, dur or 1, mag
	end
end

function screenShake:update(dt)
	if self.t < self.dur then
		self.t = self.t + dt
	end
end

function screenShake:getShake()
	local dx, dy = 0, 0
	if self.t < self.dur then
		dx = love.math.random(-self.mag, self.mag)
		dy = love.math.random(-self.mag, self.mag)
	end
	return dx, dy
end
