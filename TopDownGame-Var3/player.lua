sprites.player = love.graphics.newImage('sprites/player.png') -- adds the player sprite
player = {} -- creates table for player data to be stored
player.x = love.graphics.getWidth() / 2 -- assigns starting player x positon to 1/2 the screen width (center)
player.y = love.graphics.getHeight() / 2 -- assigns the starting player y position to the screen height (center)
player.speed = 180 -- creates initial character speed value.
player.injured = false -- creates a player injured status and is set to false
player.injuredSpeed = 270 -- sets a injured speed for the player.

function playerUpdate(dt)
    if gameState == 2 then
        local moveSpeed = player.speed -- creates a local variable within the update function to control speed
        --[[
            this if statement will adjust the moveSpeed to the injureSpeed when the player is injured
        ]]
        if player.injured then
            moveSpeed = player.injuredSpeed
        end
    --[[
        ** PLAYER MOVEMENT **
        The code below handles the player movement using the love.keyboard.isDown() function
        To compensate for framerate, moveSpeed is multiplied by dt. So if the framerate changes, the speed will adjust as needed.
        additional and is added to if statement to prevent user from moving off the screen.
    ]]
    if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then -- if statement checks if user is pressing "d" (right) and moves character
        player.x = player.x + moveSpeed*dt
    end
    if love.keyboard.isDown("a") and player.x > 0 then -- if statement checks if user is pressing "a" (left) and moves character
        player.x = player.x - moveSpeed*dt
    end
    if love.keyboard.isDown("w") and player.y > 0 then -- if statement checks if user is pressing "w" (up) and moves character
        player.y = player.y - moveSpeed*dt
    end
    if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then -- if statement checks if user is pressing "s" (down) and moves character
        player.y = player.y + moveSpeed*dt
    end
    end
end

function drawPlayer()
 --[[
        Just documenting the logic here.
        love.graphics.draw() draws the player sprite, the position going to the global player.x and player.y value.
        both nil values are for the x and y sprite scale. we aren't changing those so nil is being used.
        rather then put in a hardcoded value, :getWidth() and :getHeight() are being used on the sprite. This centers the sprite.
    ]]
    -- Checks if player is injured. If true the color of the player is changed to red.
    if player.injured then
        love.graphics.setColor(1,0,0)
    end
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2) -- draws the player sprite
end