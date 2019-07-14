Object = require('lib.classic')
Anim = require('lib.anim')
baton = require('lib.baton')
bump = require('lib.bump')
Closure = require('lib.closure')
lume = require('lib.lume')
Spritesheet = require('lib.spritesheet')
fsm = require('lib.statemachine')
tween = require('lib.tween')
Vector = require('lib.vector')

require('util')

function love.load()
    love.window.setMode(768, 600)
    love.graphics.setDefaultFilter('nearest')

    Menu = require('ui.menu')
    MainMenu = require('ui.main_menu')
    LevelSelect = require('ui.level_select')
    PauseMenu = require('ui.pause_menu')
    LevelEnd = require('ui.level_end')
    Level = require('level')

    fonts = {
        small = love.graphics.newFont('ui/BitPotion.ttf', 16),
        mid = love.graphics.newFont('ui/BitPotion.ttf', 32),
    }

    sounds = {
        click = love.audio.newSource('sfx/click.wav', 'static'),
        die = love.sound.newSoundData('sfx/die.wav'),
        explode = love.sound.newSoundData('sfx/explode.wav'),
        finish = love.audio.newSource('sfx/finish.wav', 'static'),
        grab = love.sound.newSoundData('sfx/grab.wav'),
        jump = love.sound.newSoundData('sfx/jump.wav'),
        switch = love.sound.newSoundData('sfx/switch.wav'),
        throw = love.sound.newSoundData('sfx/throw.wav'),
    }

    unlocked = getUnlocked()
    maxLevel = 18

    shaders = {
        greyscale = love.graphics.newShader([[
            vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
                vec4 pixel = Texel(texture, texture_coords);
                number average = (pixel.r + pixel.g + pixel.b) / 3;
                return vec4(average, average, average, pixel.a) * color;
            }
        ]]),
        flash = love.graphics.newShader([[
            extern number time = 0;
            vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
                vec4 pixel = Texel(texture, texture_coords);
                number whiteness = 0;
                if (time > 0.5) {
                    whiteness = pow(cos(time * 3.14), 32);
                }
                return pixel * color + vec4(whiteness, whiteness, whiteness, 0);
            }
        ]]),
    }

    input = baton.new {
        controls = {
          left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
          right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
          up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
          down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
          jump = {'key:x', 'key:space', 'button:a'},
          grab = {'key:z', 'key:rshift', 'button:x', 'button:leftshoulder'},
          pause = {'key:escape', 'button:start'},
          restart = {'key:r', 'button:y'},
        },
        pairs = {
          move = {'left', 'right', 'up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1],
      }
    
    scales = {  -- scale depending on fullscreen
        [true] = 4,
        [false] = 3,
    }
    scale = scales[false]
    tileSize = 16

    gamestate = MainMenu()
end

function filter(item, other)
    if item.kinematic and other.solid then
        return 'slide'
    elseif item.rigid and other.solid then
        return 'bounce'
    else
        return 'cross'
    end
end

function getUnlocked()
    if love.filesystem.getInfo('level.txt') then
        return tonumber(love.filesystem.read('level.txt'):sub(1, -1))
    else
        love.filesystem.newFile('level.txt')
        love.filesystem.write('level.txt', '1')
        return 1
    end
end

function love.update(dt)
    dt = math.min(dt, 1/30)
    input:update()
    gamestate:update(dt)
end

function love.draw()
    love.graphics.print(love.timer.getFPS())
    love.graphics.scale(scale, scale)
    gamestate:draw()
end

function love.quit()
    love.filesystem.write('level.txt', tostring(unlocked))
end