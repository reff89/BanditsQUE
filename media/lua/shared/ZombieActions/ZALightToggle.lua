ZombieActions = ZombieActions or {}

ZombieActions.LightToggle = {}
ZombieActions.LightToggle.onStart = function(zombie, task)
    return true
end

ZombieActions.LightToggle.onWorking = function(zombie, task)
    if not zombie:getVariableString("BumpAnimFinished") then
        return false
    else
        return true
    end
end

ZombieActions.LightToggle.onComplete = function(zombie, task)
    local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
    if square then
        local objects = square:getObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if instanceof(object, "IsoLightSwitch") then
                object:setActive(task.active)
            end
        end
    end
    return true
end

