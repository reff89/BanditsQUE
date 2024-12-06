ZombieActions = ZombieActions or {}

ZombieActions.FillWater = {}
ZombieActions.FillWater.onStart = function(zombie, task)
    local inventory = zombie:getInventory()
    local item = inventory:getItemFromType(task.itemType)
    if item then
        zombie:setPrimaryHandItem(item)
        inventory:Remove(item)
        Bandit.UpdateItemsToSpawnAtDeath(zombie)
    end
    return true
end

ZombieActions.FillWater.onWorking = function(zombie, task)
    zombie:faceLocation(task.x, task.y)
    if task.time <= 0 then
        return true
    else
        local bumpType = zombie:getBumpType()
        if bumpType ~= task.anim then 
            zombie:playSound("GetWaterFromTapMetalBig") -- GetWaterFromLake
            zombie:setBumpType(task.anim)
        end
    end
end

ZombieActions.FillWater.onComplete = function(zombie, task)
    zombie:getEmitter():stopAll()

    local item = zombie:getPrimaryHandItem()
    if not instanceof(item, "DrainableComboItem") then return end

    local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
    if not square then return true end

    local objects = square:getObjects()
    local source
    local waterAvailable
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local waterAmount = object:getWaterAmount()
        if waterAmount > 0 then
            source = object
            waterAvailable = waterAmount
            break
        end
    end
    if not source then return true end

    local waterToTake = math.floor((1 - item:getUsedDelta()) / item:getUseDelta() + 0.5)
    if waterAvailable < waterToTake then waterToTake = waterAvailable end
    local waterLeft = waterAvailable - waterToTake

    if BanditUtils.IsController(zombie) then
        local idx = source:getObjectIndex()
        local args = {x=task.x, y=task.y, z=task.z, index=idx, amount=waterLeft}
        sendClientCommand(getPlayer(), 'object', 'setWaterAmount', args)
    end

    local newWater = (item:getUsedDelta() + waterToTake * item:getUseDelta())
    if newWater > 1 then newWater = 1 end
    item:setUsedDelta(newWater)
    
    local inventory = zombie:getInventory()
    inventory:AddItem(item)
    Bandit.UpdateItemsToSpawnAtDeath(zombie)

    return true
end

