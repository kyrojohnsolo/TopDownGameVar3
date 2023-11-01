--Lesson Complete!

function love.load() -- this function loads everything when game starts
    math.randomseed(os.time())
    sprites = {} -- creates table for sprites to be stored
    sprites.background = love.graphics.newImage('sprites/background.png') -- adds the background sprite
    sprites.bullet = love.graphics.newImage('sprites/bullet.png') -- adds the bullet sprite
    sprites.player = love.graphics.newImage('sprites/player.png') -- adds the player sprite
    sprites.zombie = love.graphics.newImage('sprites/zombie.png') -- adds the zombie sprite

    player = {} -- creates table for player data to be stored
    player.x = love.graphics.getWidth() / 2 -- assigns starting player x positon to 1/2 the screen width (center)
    player.y = love.graphics.getHeight() / 2 -- assigns the starting player y position to the screen height (center)
    player.speed = 180 -- creates initial character speed value.
    
    myFont = love.graphics.newFont(30)
    
    zombies = {} -- create global zombies table. function spawnZombie() creates and adds zombies to this table.
    bullets = {} -- create global bullets table. function spawnBullet() creates and adds zombies to this table.

    gameState = 1 -- gameState 1 is the mainmenu, gameState 2 is when user is playing the game
    score = 0 -- score is initally set to 0
    maxTime = 2 -- maxTime is used for zombie timer.
    timer = maxTime -- timer is used for zombie timer.
end

function love.update(dt) -- this is the "game loop" that runs at 60FPS
    if gameState == 2 then
    --[[
        ** PLAYER MOVEMENT **
        The code below handles the player movement using the love.keyboard.isDown() function
        To compensate for framerate, player.speed is multiplied by dt. So if the framerate changes, the speed will adjust as needed.
        additional and is added to if statement to prevent user from moving off the screen.
    ]]
    if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then -- if statement checks if user is pressing "d" (right) and moves character
        player.x = player.x + player.speed*dt
    end
    if love.keyboard.isDown("a") and player.x > 0 then -- if statement checks if user is pressing "a" (left) and moves character
        player.x = player.x - player.speed*dt
    end
    if love.keyboard.isDown("w") and player.y > 0 then -- if statement checks if user is pressing "w" (up) and moves character
        player.y = player.y - player.speed*dt
    end
    if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then -- if statement checks if user is pressing "s" (down) and moves character
        player.y = player.y + player.speed*dt
    end
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
                gameState = 1
                player.x = love.graphics.getWidth() / 2 
                player.y = love.graphics.getHeight() / 2
            end
        end
    end
    --[[
        **BULLET DIRECTION**
        this loops goes through the bullets table and gives them the direction and speed they should go.
        This uses the same logic as the zombie with cosine and sine.
        we multiply that by the speed.
    ]]
    for i,b in ipairs(bullets) do
        b.x = b.x + (math.cos(b.direction) * b.speed*dt)
        b.y = b.y + (math.sin(b.direction) * b.speed*dt)
    end

    --[[
        **REMOVEING BULLETS WHEN LEAVING THE SCREEN**
        this for loop iterates through the number of bullets of the table starting from the bottom
        the if statement checks the bullet position, if it goes beyond the screen it is removed from the table.
    ]]
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
    --[[
        **BULLET AND ZOMBIE COLLISION DETECTION**
        this is a nested loop for zombies and bullets that checks the distances between the zombie and bullets.
        When the less-than distance is met, the zombie and bullet status is set to "dead"
    ]]
    for i,z in ipairs(zombies) do
        for j,b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                score = score + 1
            end
        end
    end
    --[[
        **REMOVE DEAD ZOMBIES**
        The following for loop checks the dead status of all zombies.
        if dead status is found to be true, the zombie is then removed from the table.
    ]]
    for i=#zombies, 1, -1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
    end
    --[[
        **REMOVE DEAD BULLETS**
        The following for loop checks the dead status of all bullets.
        if dead status is found to be true, the bullet is then removed from the table.
    ]]
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end
    --[[
        **ZOMBIE SPAWN TIMER**
        timer counts down to zero and spawns zombie.
        maxTime is reduced to increase spawn speed
    ]]
    if gameState == 2 then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
end

function love.draw() -- this function handles drawing the graphics.
    --https://love2d.org/wiki/love.graphics.draw
    love.graphics.draw(sprites.background, 0, 0) -- draws the background

    --[[
        during gamestate = 1 , user is prompted to click anywhere to begin game.
    ]]
    if gameState == 1 then
        love.graphics.setFont(myFont)
        love.graphics.printf("Click anywhere to begin!", 0, 50, love.graphics.getWidth(), "center")
    end
    --[[
        score is printed at the bottom of the screen.
    ]]
    love.graphics.printf("score: " .. score, 0, love.graphics.getHeight() -100, love.graphics.getWidth(), "center")

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
    --[[
        this loops goes through the bullets table and draws them to the screen
        setting the sx and sy parameter as .5 will scale down the bullet size.
        rather then put in a hardcoded value, :getWidth() and :getHeight() are being used on the sprite. This centers the sprite.
    ]]
    for i,b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, .5, .5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
end

function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end
--[[
    this activates the bullets when mouse 1 is clicked.
    bullets will only fire when gameState = 2
]]
function love.mousepressed(x, y, button)
    if button == 1 and gameState == 2 then
        spawnBullet()
    elseif button == 1 and gameState == 1 then -- this will reset game after player is caught.
        gameState = 2
        maxTime = 2
        timer = maxTime
        score = 0
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
    zombie.x = 0 -- creates x position variable
    zombie.y = 0 -- creates y position variable
    zombie.speed = 140 -- assigns the zombie speed
    zombie.dead = false -- when zombie collides with bullet, dead will be set to true and the zombie is removed.

    --[[
        **RANDOM ZOMBIE PLACEMENT**
        Goal here is to have zombies walk in from random spot off the screen.
        side variable gets a random number 1-4 which represents each side of the screen.
        1 = left, 2 = right, 3 = top, 4 = bottom

    ]]
    local side = math.random(1,4)
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end

    table.insert(zombies, zombie) -- adds the local "zombie" to the global "zombies" table.

end

--[[
    this function creates the bullet and assigns the bullet to the global "bullets" table
]]
function spawnBullet()
    local bullet = {} -- creates local bullets table
    bullet.x = player.x -- assigns position x to player location
    bullet.y = player.y -- assigns position y to player location 
    bullet.speed = 500 -- assings the bullet speed
    bullet.direction = playerMouseAngle() -- uses the player mouse angle for the direction of the bullet will go
    bullet.dead = false -- when bullets collide with zombies, dead will be set to true and bullet is removed
    table.insert(bullets, bullet) -- inserts bullet into global bullets table.
end

--[[
    this is the distance between formula that we used in the previous lesson. This simply calculates the distance between two objects.
]] 
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end