--Lesson Complete! Have also completed extra lessons and added the crosshair from the previous lesson.

function love.load() -- this function loads everything when game starts
    math.randomseed(os.time())
    sprites = {} -- creates table for sprites to be stored
    sprites.background = love.graphics.newImage('sprites/background.png') -- adds the background sprite
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png') -- adds the crosshair sprite
    myFont = love.graphics.newFont(30)
    gameState = 1 -- gameState 1 is the mainmenu, gameState 2 is when user is playing the game
    score = 0 -- score is initally set to 0
    love.mouse.setVisible(false) -- makes the mouse no longer visible.
    require ('enemies/zombies')
    require ('enemies/targets')
    require ('dabrain/bullets')
    require ('player')
    require('dabrain/monsterTimer')
end

function love.update(dt) -- this is the "game loop" that runs at 60FPS
    playerUpdate(dt)
    -- insert zombie.lua function here
    zombiesUpdate(dt)    
    -- insert targets update function here
    targetsUpdate(dt)
    -- insert bullet logic here
    hitWithBullets(dt)
    -- insert monsterTimer logic here
    monsterTimer(dt)
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
    drawPlayer()
    drawZombies()
    drawTargets()
    love.graphics.setColor(1,1,1)
    drawBullets()
    -- this draws the crosshair sprite, and assigns the position to the mouseX and mouseY position.
    --  also, you need to subtract the PNG size to correct for the offset position of the PNG
    love.graphics.draw(sprites.crosshairs, love.mouse.getX()-20, love.mouse.getY()-20, nil, .75, .75)   
end


function love.keypressed(key)
    if key == "1" then
        spawnZombie()
    end
end

function love.keypressed(key)
    if key == "2" then
        spawnTarget()
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
function monsterSelector()
    monsterSelection = math.random(1,2)
    if monsterSelection == 1 then
        spawnZombie()
    else
        spawnTarget()
    end
end

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

    function spawnTarget()
        local target = {} -- creates local zombie variable
        target.x = 0 -- creates x position variable
        target.y = 0 -- creates y position variable
        target.speed = 140 -- assigns the zombie speed
        target.dead = false -- when zombie collides with bullet, dead will be set to true and the zombie is removed.
        target.injured = false

        --[[
            **RANDOM ZOMBIE PLACEMENT**
            Goal here is to have zombies walk in from random spot off the screen.
            side variable gets a random number 1-4 which represents each side of the screen.
            1 = left, 2 = right, 3 = top, 4 = bottom

        ]]
        local side = math.random(1,4)
        if side == 1 then
            target.x = -30
            target.y = math.random(0, love.graphics.getHeight())
        elseif side == 2 then
            target.x = love.graphics.getWidth() + 30
            target.y = math.random(0, love.graphics.getHeight())
        elseif side == 3 then
            target.x = math.random(0, love.graphics.getWidth())
            target.y = -30
        elseif side == 4 then
            target.x = math.random(0, love.graphics.getWidth())
            target.y = love.graphics.getHeight() + 30
        end

        table.insert(targets, target) -- adds the local "zombie" to the global "zombies" table.
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