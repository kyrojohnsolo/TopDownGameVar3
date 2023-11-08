sprites.bullet = love.graphics.newImage('sprites/bullet.png') -- adds the bullet sprite
bullets = {} -- create global bullets table. function spawnBullet() creates and adds zombies to this table.

function hitWithBullets(dt)
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
    for i,z in ipairs(targets) do
        for j,b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 and z.injured == false then
                z.injured = true
                b.dead = true
            elseif distanceBetween(z.x, z.y, b.x, b.y) < 20 and z.injured == true then
                z.dead = true
                b.dead = true
                score = score + 2
            end
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
end

function drawBullets()
--[[
        this loops goes through the bullets table and draws them to the screen
        setting the sx and sy parameter as .5 will scale down the bullet size.
        rather then put in a hardcoded value, :getWidth() and :getHeight() are being used on the sprite. This centers the sprite.
    ]]
    
    for i,b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, .5, .5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
end