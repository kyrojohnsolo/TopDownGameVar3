maxTime = 2 -- maxTime is used for zombie timer.
timer = maxTime -- timer is used for zombie timer.
function monsterTimer(dt)    
    --[[
        **ZOMBIE SPAWN TIMER**
        timer counts down to zero and spawns zombie.
        maxTime is reduced to increase spawn speed
    ]]
    if gameState == 2 then
        timer = timer - dt
        if timer <= 0 then
            monsterSelector()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
end