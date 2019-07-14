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