--[[
    This function creates the zombie and assigns the zombie to the global "zombies" table.
]]
function monsterSelector()
    monsterSelection = math.random(1,3)
    if monsterSelection == 1 then
        spawnZombie()
    elseif monsterSelection == 2 then
        spawnTarget()
    elseif monsterSelection == 3 then
        spawnSkull()
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

function spawnSkull()
    local skull = {} -- creates local zombie variable
    skull.x = 0 -- creates x position variable
    skull.y = 0 -- creates y position variable
    skull.speed = 140 -- assigns the zombie speed
    skull.dead = false -- when zombie collides with bullet, dead will be set to true and the zombie is removed.
    skull.health = 2

    --[[
        **RANDOM ZOMBIE PLACEMENT**
        Goal here is to have zombies walk in from random spot off the screen.
        side variable gets a random number 1-4 which represents each side of the screen.
        1 = left, 2 = right, 3 = top, 4 = bottom

    ]]
    local side = math.random(1,4)
    if side == 1 then
        skull.x = -30
        skull.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        skull.x = love.graphics.getWidth() + 30
        skull.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        skull.x = math.random(0, love.graphics.getWidth())
        skull.y = -30
    elseif side == 4 then
        skull.x = math.random(0, love.graphics.getWidth())
        skull.y = love.graphics.getHeight() + 30
    end

    table.insert(skulls, skull) -- adds the local "zombie" to the global "zombies" table.
end