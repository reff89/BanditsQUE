ZombieActions = ZombieActions or {}

ZombieActions.SmashWindow = {}
ZombieActions.SmashWindow.onStart = function(zombie, task)
    return true
end

ZombieActions.SmashWindow.onWorking = function(zombie, task)
    zombie:faceLocationF(task.x, task.y)
    if not zombie:getVariableString("BumpAnimFinished") then
        return false
    else
        return true
    end
end

ZombieActions.SmashWindow.onComplete = function(zombie, task)

    local cell = zombie:getSquare():getCell()
    local square = cell:getGridSquare(task.x, task.y, task.z)
    if square then
        local window = square:getWindow()
        if window then
            window:smashWindow()
        end
    end
    return true
end