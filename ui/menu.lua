Menu = Object:extend()

local background = love.graphics.newImage('gfx/background.png')

Menu.Button = require('ui.button')
Menu.Text = require('ui.text')

Menu.buttonSize = Vector(70, 25)

function Menu:new()
    
end

function Menu.toggleFullscreen()
    local _, _, flags = love.window.getMode()
    love.window.setFullscreen(not flags.fullscreen)
    scale = scales[not flags.fullscreen]
    gamestate = gamestate.__index()
end

function Menu.toggleSound()
    love.audio.setVolume(1 - love.audio.getVolume())
    gamestate = gamestate.__index()
end

function Menu.toggleMusic()
    music:setVolume(math.max(musicDefaultVol - music:getVolume(), 0))
    gamestate = gamestate.__index()
end

function Menu.getFullscreen()
    local _, _, flags = love.window.getMode()
    if flags.fullscreen then
        return 'windowed'
    else
        return 'fullscreen'
    end
end

function Menu.getSound()
    if love.audio.getVolume() == 0 then
        return 'off'
    else
        return 'on'
    end
end

function Menu.getMusic()
    if music and music:getVolume() == 0 then
        return 'off'
    else
        return 'on'
    end
end

function Menu:update(dt)
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Menu:draw()
    love.graphics.draw(background, -70, -70)
    for _, button in ipairs(self.buttons) do
        button:draw()
    end    
    for _, text in ipairs(self.texts) do
        text:draw()
    end
end

return Menu