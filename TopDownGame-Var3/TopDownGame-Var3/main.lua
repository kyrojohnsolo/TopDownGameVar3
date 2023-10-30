--Currently on lesson 41

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
    
    zombies = {} -- create global zombies table. function spawnZombie() creates and adds zombies to this table.
end

function love.update(dt) -- this is the "game loop" that runs at 60FPS
    --[[
        ** PLAYER MOVEMENT **
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

    --[[
        Documenting Logic
        this loop goes through the zombie table and directs them towards the player.
        This is covered in lesson 39 of the Udemy course, using the Unit Circle diagram.
        using cosine and sine we can determine the direction that the zombies need to go. 
        we can then multiply by the speed to give them the correct speed to approach the players.
    ]]
    for i,z in ipairs(zombies) do
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed*dt)
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed*dt)
        --[[
            ** COLLISION  DETECTION **
            Here we use the distance between formula to do collision detection between the player and zombies
                if the distance is less then a certain amount, we use a for loop to loop through our zombie table and set the value to nil deleting them
        ]]
        if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
            for i,z in ipairs(zombies) do
                zombies[i] = nil
            end
        end
    end
end

function love.draw() -- this function handles drawing the graphics.
    --https://love2d.org/wiki/love.graphics.draw
    love.graphics.draw(sprites.background, 0, 0) -- draws the background
    --[[
        Just documenting the logic here.
        love.graphics.draw() draws the player sprite, the position going to the global player.x and player.y value.
        both nil values are for the x and y sprite scale. we aren't changing those so nil is being used.
        rather then put in a hardcoded value, :getWidth() and :getHeight() are being used on the sprite. This centers the sprite.
    ]]
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2) -- draws the player sprite

    --[[
        Documenting Zombie Logic
        this for loop goes through each "zombie" in the "zombies" table.
        zombiePlayerAngle() will make the zombies face the player
        both nil values are for the x and y sprite scale. we aren't changing those so nil is being used.
        rather then put in a hardcoded value, :getWidth() and :getHeight() are being used on the sprite. This centers the sprite.

    ]]
    for i,z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2 ) -- draws zombies, "z" == individual zombie.
    end
end

function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end

function playerMouseAngle()
    --[[
        We are using this formlua to have the player face the mouse direction: atan2(y1 - y2, x1- x2)
        **NOTE** the way we set this up, the player is facing the opposite direction. We correct this by adding math.pi
        **NOTE** this is covered in lesson 36 of Udemy Course.
    ]]
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function zombiePlayerAngle(enemy)
    --[[
        We are using this formlua to have the zombies face player: atan2(y1 - y2, x1- x2)
        We simply are copying the playerMouseAngle() function and swapping out the mouse for the zombies.
        We need a parameter to pass in our for loop, so we will use "enemy"
        **NOTE** this is covered in lesson 38 of Udemy Course.
    ]]
    return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

--[[
    This function creates the zombie and assigns the zombie to the global "zombies" table.
]]
function spawnZombie()
    local zombie = {} -- creates local zombie variable
    zombie.x = math.random(0, love.graphics.getWidth()) -- assigns position X to random number on screen
    zombie.y = math.random(0, love.graphics.getHeight()) -- assigns position Y to random number on screen
    zombie.speed = 140 -- assigns the zombie speed
    table.insert(zombies, zombie) -- adds the local "zombie" to the global "zombies" table.

end

--[[
    this is the distance between formula that we used in the previous lesson. This simply calculates the distance between two objects.
]] 
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end