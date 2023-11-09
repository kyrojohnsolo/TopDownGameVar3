sprites.target = love.graphics.newImage('sprites/target.png') -- adds the zombie sprite
targets = {}

function targetsUpdate(dt)
    for i,z in ipairs(targets) do
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
        
            for i,z in ipairs(targets) do
                targets[i] = nil
                for j,b in ipairs(zombies) do
                    zombies[j] = nil
                end
                gameState = 1
                player.injured = false
                player.x = love.graphics.getWidth() / 2 
                player.y = love.graphics.getHeight() / 2
            end
        end
        end
    end
    for i=#targets, 1, -1 do
        local z = targets[i]
        if z.dead == true then
            table.remove(targets, i)
        end
    end
end

function drawTargets()
    for i,z in ipairs(targets) do
        if z.injured == true then
            love.graphics.setColor(1,0,0)
            love.graphics.draw(sprites.target, z.x, z.y, zombiePlayerAngle(z), .5, .5, sprites.target:getWidth()/2, sprites.target:getHeight()/2 ) -- draws zombies, "z" == individual zombie.
        else
            love.graphics.setColor(1,1,1)
            love.graphics.draw(sprites.target, z.x, z.y, zombiePlayerAngle(z), .5, .5, sprites.target:getWidth()/2, sprites.target:getHeight()/2 ) -- draws zombies, "z" == individual zombie.
        end
    end
end