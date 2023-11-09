sprites.zombie = love.graphics.newImage('sprites/zombie.png') -- adds the zombie sprite
zombies = {} -- create global zombies table. function spawnZombie() creates and adds zombies to this table.

function zombiesUpdate(dt)
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
            --[[
                if else statement that checks the players injured status.
                if not injured, the injured status is set to true and the colliding zombie is destroyed.
                if the player is injured, the game is over.
            ]]
            if player.injured == false then
                player.injured = true
                z.dead = true
            else
        
            for i,z in ipairs(zombies) do
                zombies[i] = nil
                for j,b in ipairs(targets) do
                    targets[j] = nil
                end
                gameState = 1
                player.injured = false
                player.x = love.graphics.getWidth() / 2 
                player.y = love.graphics.getHeight() / 2
            end
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
end

function drawZombies()
--[[
        Documenting Zombie Logic
        this for loop goes through each "zombie" in the "zombies" table.
        zombiePlayerAngle() will make the zombies face the player
        both nil values are for the x and y sprite scale. we aren't changing those so nil is being used.
        rather then put in a hardcoded value, :getWidth() and :getHeight() are being used on the sprite. This centers the sprite.

    ]]
    love.graphics.setColor(1,1,1)
    for i,z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2 ) -- draws zombies, "z" == individual zombie.
    end
end