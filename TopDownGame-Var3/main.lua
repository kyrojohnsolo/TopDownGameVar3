--Currently on lesson 37

function love.load() -- this function loads everything when game starts
    sprites = {} -- creates table for sprites to be stored
    sprites.background = love.graphics.newImage('sprites/background.png') -- adds the background sprite
    sprites.bullet = love.graphics.newImage('sprites/bullet.png') -- adds the bullet sprite
    sprites.player = love.graphics.newImage('sprites/player.png') -- adds the player sprite
    sprites.zombie = love.graphics.newImage('sprites/zombie.png') -- adds the zombie sprite

    player = {} -- creates table for player data to be stored
    player.x = love.graphics.getWidth() / 2 -- assigns starting player x positon to 1/2 the screen width (center)
    player.y = love.graphics.getHeight() / 2 -- assigns the starting player y position to the screen height (center)
    player.speed = 180 -- creates initial character speed value.
    tempRotation = 0
end

function love.update(dt) -- this is the "game loop" that runs at 60FPS
    --[[
        The code below handles the player movement using the love.keyboard.isDown() function
        To compensate for framerate, player.speed is multiplied by dt. So if the framerate changes, the speed will adjust as needed.
    ]]
    if love.keyboard.isDown("d") then -- if statement checks if user is pressing "d" (right) and moves character
        player.x = player.x + player.speed*dt
    end
    if love.keyboard.isDown("a") then -- if statement checks if user is pressing "a" (left) and moves character
        player.x = player.x - player.speed*dt
    end
    if love.keyboard.isDown("w") then -- if statement checks if user is pressing "w" (up) and moves character
        player.y = player.y - player.speed*dt
    end
    if love.keyboard.isDown("s") then -- if statement checks if user is pressing "s" (down) and moves character
        player.y = player.y + player.speed*dt
    end
    tempRotation = tempRotation + 0.01
end

function love.draw() -- this function handles drawing the graphics.
    --https://love2d.org/wiki/love.graphics.draw
    love.graphics.draw(sprites.background, 0, 0) -- draws the background
    --[[
        Just documenting the logic here.
        love.graphics.draw() draws the player sprite, the position going to the global player.x and player.y value.
        tempRotation will change
        both nil values are for the sprite scale. we aren't changing those so nil is being used.
        rather then put in a hardcoded value, :getWidth() and :getHeight() are being used on the sprite. This centers the sprite.
    ]]
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2) -- draws the player sprite
end


function playerMouseAngle()
    --[[
        We are using this formlua to have the player face the mouse direction: atan2(y1 - y2, x1- x2)
        **NOTE** the way we set this up, the player is facing the opposite direction. We correct this by adding math.pi
        **NOTE** this is covered in lesson 36 of Udemy Course.
    ]]
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end
