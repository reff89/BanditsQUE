BanditUtils = BanditUtils or {}

BanditUtils.ItemVisuals = {
    ["Base.ZedDmg_BACK_Slash"] = true,
    ["Base.ZedDmg_BACK_Spine"] = true,
    ["Base.ZedDmg_BellySlashLeft"] = true,
    ["Base.ZedDmg_BellySlashRight"] = true,
    ["Base.ZedDmg_BELLY_Bullet"] = true,
    ["Base.ZedDmg_BELLY_Shotgun"] = true,
    ["Base.ZedDmg_BELLY_Skin"] = true,
    ["Base.ZedDmg_BELLY_Slash"] = true,
    ["Base.ZedDmg_BulletBelly01"] = true,
    ["Base.ZedDmg_BulletBelly02"] = true,
    ["Base.ZedDmg_BulletBelly03"] = true,
    ["Base.ZedDmg_BulletChest01"] = true,
    ["Base.ZedDmg_BulletChest02"] = true,
    ["Base.ZedDmg_BulletChest03"] = true,
    ["Base.ZedDmg_BulletChest04"] = true,
    ["Base.ZedDmg_BulletFace01"] = true,
    ["Base.ZedDmg_BulletFace02"] = true,
    ["Base.ZedDmg_BulletForehead01"] = true,
    ["Base.ZedDmg_BulletForehead02"] = true,
    ["Base.ZedDmg_BulletForehead03"] = true,
    ["Base.ZedDmg_BulletLeftTemple"] = true,
    ["Base.ZedDmg_BulletRightTemple"] = true,
    ["Base.ZedDmg_ChestSlashLeft"] = true,
    ["Base.ZedDmg_CHEST_Bullet"] = true,
    ["Base.ZedDmg_CHEST_Shotgun"] = true,
    ["Base.ZedDmg_CHEST_Slash"] = true,
    ["Base.ZedDmg_FaceSkullLeft"] = true,
    ["Base.ZedDmg_FaceSkullRight"] = true,
    ["Base.ZedDmg_HeadSlashCentre01"] = true,
    ["Base.ZedDmg_HeadSlashCentre02"] = true,
    ["Base.ZedDmg_HeadSlashCentre03"] = true,
    ["Base.ZedDmg_HeadSlashLeft01"] = true,
    ["Base.ZedDmg_HeadSlashLeft02"] = true,
    ["Base.ZedDmg_HeadSlashLeft03"] = true,
    ["Base.ZedDmg_HeadSlashLeftBack01"] = true,
    ["Base.ZedDmg_HeadSlashLeftBack02"] = true,
    ["Base.ZedDmg_HeadSlashRight01"] = true,
    ["Base.ZedDmg_HeadSlashRight02"] = true,
    ["Base.ZedDmg_HeadSlashRight03"] = true,
    ["Base.ZedDmg_HeadSlashRightBack01"] = true,
    ["Base.ZedDmg_HeadSlashRightBack02"] = true,
    ["Base.ZedDmg_HEAD_Bullet"] = true,
    ["Base.ZedDmg_HEAD_Shotgun"] = true,
    ["Base.ZedDmg_HEAD_Skin"] = true,
    ["Base.ZedDmg_HEAD_Slash"] = true,
    ["Base.ZedDmg_Mouth01"] = true,
    ["Base.ZedDmg_Mouth02"] = true,
    ["Base.ZedDmg_MouthLeft"] = true,
    ["Base.ZedDmg_MouthRight"] = true,
    ["Base.ZedDmg_NeckBiteBackLeft"] = true,
    ["Base.ZedDmg_NeckBiteBackRight"] = true,
    ["Base.ZedDmg_NeckBiteFrontLeft"] = true,
    ["Base.ZedDmg_NeckBiteFrontRight"] = true,
    ["Base.ZedDmg_NECK_Bite"] = true,
    ["Base.ZedDmg_NoChin"] = true,
    ["Base.ZedDmg_NoEarLeft"] = true,
    ["Base.ZedDmg_NoEarRight"] = true,
    ["Base.ZedDmg_NoNose"] = true,
    ["Base.ZedDmg_RibsLeft"] = true,
    ["Base.ZedDmg_RibsRight"] = true,
    ["Base.ZedDmg_ShotgunBelly"] = true,
    ["Base.ZedDmg_ShotgunChestCentre"] = true,
    ["Base.ZedDmg_ShotgunChestLeft"] = true,
    ["Base.ZedDmg_ShotgunChestRight"] = true,
    ["Base.ZedDmg_ShotgunFaceFull"] = true,
    ["Base.ZedDmg_ShotgunFaceLeft"] = true,
    ["Base.ZedDmg_ShotgunFaceRight"] = true,
    ["Base.ZedDmg_ShotgunLeft"] = true,
    ["Base.ZedDmg_ShotgunRight"] = true,
    ["Base.ZedDmg_ShoulderSlashLeft"] = true,
    ["Base.ZedDmg_ShoulderSlashRight"] = true,
    ["Base.ZedDmg_SkullCap"] = true,
    ["Base.ZedDmg_SkullUpLeft"] = true,
    ["Base.ZedDmg_SkullUpRight"] = true,
}

function BanditUtils.GetCharacterID (character)

    -- the following has proven to be much less efficient
    local function toBits(num)
        local bits = string.split(string.reverse(Long.toUnsignedString(num, 2)), "")
        while #bits < 16 do bits[#bits+1] = "0" end
        return bits
    end
    
    local function toDec(bits)
        local decimal = Long.parseUnsignedLong(string.reverse(table.concat(bits, "")), 2)
        return decimal
    end

    if instanceof(character, "IsoZombie") then
        -- local id = character:getVariableString("BanditID")
        -- if false and id and id ~= "" then
        --     return tonumber(id)
        -- else
        local id
        local dec = character:getPersistentOutfitID()

        local bits = toBits(dec)
        local hat = bits[16]
        if hat == "1" then
            bits[16] = "0"
            id = toDec(bits)
        else
            id = dec
        end
            -- character:setVariable("BanditID", tostring(id))
        return id
        -- end
    end
    
    if instanceof(character, "IsoPlayer") then
        local world = getWorld()
        local gamemode = world:getGameMode()
        local id = false
        if gamemode == "Multiplayer" then
            id = character:getOnlineID()
        else
            id = 1
        end
        return id
    end
end
    
function BanditUtils.IsController(zombie)

    -- ZOMBIE/BANDIT BEHAVIOUR IS FULLY CLIENT CONTROLLED
    -- SO CLIENTS ARE MIRRORING ACTIONS FOR ZOMBIES
    -- NOW, WE WANT VISUAL MIRRORING BY ALL CLIENTS 
    -- BUT THE ACTUAL ACTION CONSEQUENCES TO HAPPEN ONCE

    local gamemode = getWorld():getGameMode()

    if gamemode ~= "Multiplayer" then return true end

    local zx = zombie:getX()
    local zy = zombie:getY()

    local bestDist = 10000
    local bestPlayerId
    local playerList = getOnlinePlayers()
    for i=0, playerList:size()-1 do
        local player = playerList:get(i)
        local px = player:getX()
        local py = player:getY()

        local dist = BanditUtils.DistTo(zx, zy, px, py)
        if dist < bestDist then
            bestDist = dist
            bestPlayerId = BanditUtils.GetCharacterID(player)
        end
    end
    return bestPlayerId == BanditUtils.GetCharacterID(getPlayer())
end

function BanditUtils.IsInAngle(observer, targetX, targetY)
    
    local omega = observer:getDirectionAngle()
    local targer_delta_x = targetX - observer:getX()
    local targer_delta_y = targetY - observer:getY()
    local theta = 57.295779513 * math.atan(targer_delta_y / targer_delta_x)

    -- print ("omega:" .. omega)
    -- print ("theta:" .. theta)

    if math.abs(theta - omega) < 45 then 
        return true
    else
        return false
    end
end

function BanditUtils.CalcAngle (x1, y1, x2, y2)

    -- Calculate the difference in coordinates
    local dx = x2 - x1
    local dy = y2 - y1

    -- Use atan2 to get the angle in radians
    local angleRadians = math.atan2(dy, dx)

    -- Convert radians to degrees
    local angleDegrees = math.deg(angleRadians)

    -- Ensure the angle is within the range -180 to 180
    return angleDegrees
end


function BanditUtils.GetClosestPlayerLocation(character, mustSee)
    local result = {}
    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false
    result.id = false

    local cx, cy = character:getX(), character:getY()
    local playerList = BanditPlayer.GetPlayers()

    for i=0, playerList:size()-1 do
        local player = playerList:get(i)
        if player and not BanditPlayer.IsGhost(player) then
            local px, py = player:getX(), player:getY()
            local dist = BanditUtils.DistTo(cx, cy, px, py)
            if dist < result.dist and (not mustSee or (character:CanSee(player) and dist < SandboxVars.Bandits.General_RifleRange)) then
                result.dist = dist
                result.x = player:getX()
                result.y = player:getY()
                result.z = player:getZ()
                result.id = BanditUtils.GetCharacterID(player)
            end
        end
    end
    return result
end

function BanditUtils.GetClosestZombieLocation(character)
    local result = {}
    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false
    result.id = false
    
    local cx, cy = character:getX(), character:getY()

    local zombieList = BanditZombie.GetAllZ()
    for id, zombie in pairs(zombieList) do
        local dist = BanditUtils.DistTo(cx, cy, zombie.x, zombie.y)
        if dist < result.dist then
            result.dist = dist
            result.x = zombie.x
            result.y = zombie.y
            result.z = zombie.z
            result.id = zombie.id
        end
    end

    return result
end

function BanditUtils.GetClosestBanditLocation(character)
    local result = {}
    local cid = BanditUtils.GetCharacterID(character)

    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false
    result.id = false
    
    local cx, cy = character:getX(), character:getY()

    local zombieList = BanditZombie.GetAllB()
    for id, zombie in pairs(zombieList) do
        local dist = BanditUtils.DistTo(cx, cy, zombie.x, zombie.y)
        if dist < result.dist and cid ~= id then
            result.dist = dist
            result.x = zombie.x
            result.y = zombie.y
            result.z = zombie.z
            result.id = zombie.id
        end
    end

    return result
end

function BanditUtils.GetClosestBanditLocationFast(character)
    local result = {}
    local cid = BanditUtils.GetCharacterID(character)

    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false
    result.id = false
    
    local cx, cy = character:getX(), character:getY()

    local zombieList = BanditZombie.GetAllB()
    for id, zombie in pairs(zombieList) do
        if math.abs(zombie.x - cx) < 30 or math.abs(zombie.y - cy) < 30 then
            local dist = BanditUtils.DistTo(cx, cy, zombie.x, zombie.y)
            if dist < result.dist and cid ~= id then
                result.dist = dist
                result.x = zombie.x
                result.y = zombie.y
                result.z = zombie.z
                result.id = zombie.id
            end
        end
    end

    return result
end

function BanditUtils.GetClosestEnemyBanditLocation(character)
    local result = {}
    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false
    result.id = false

    local cx, cy = character:getX(), character:getY()

    local banditList = BanditZombie.GetAllB()
    if instanceof(character, "IsoZombie") then
        local brain = BanditBrain.Get(character)
        for id, otherBandit in pairs(banditList) do
            if brain.clan ~= otherBandit.brain.clan and (brain.hostile or otherBandit.brain.hostile) then
                local dist = BanditUtils.DistTo(cx, cy, otherBandit.x, otherBandit.y)
                if dist < result.dist then
                    result.dist = dist
                    result.x = otherBandit.x
                    result.y = otherBandit.y
                    result.z = otherBandit.z
                    result.id = otherBandit.id
                end
            end
        end
    end

    if instanceof(character, "IsoPlayer") then
        for id, otherBandit in pairs(banditList) do
            if otherBandit.brain.hostile then
                local dist = BanditUtils.DistTo(cx, cy, otherBandit.x, otherBandit.y)
                if dist < result.dist then
                    result.dist = dist
                    result.x = otherBandit.x
                    result.y = otherBandit.y
                    result.z = otherBandit.z
                    result.id = otherBandit.id
                end
            end
        end
    end
    return result
end

function BanditUtils.GetMoveTask(endurance, x, y, z, walkType, dist, closeSlow)
    -- Move and GoTo generally do the same thing with a different method
    -- GoTo uses one-time move order, provides better synchronization in multiplayer, not perfect on larger distance
    -- Move uses constant updatating, it a better algorithm but introduces desync in multiplayer

    local gamemode = getWorld():getGameMode()
    local task
    if gamemode == "Multiplayer" then
        if dist > 30 then
            task = {action="Move", time=35, endurance=endurance, x=x, y=y, z=z, walkType=walkType, closeSlow=closeSlow}
        else
            task = {action="GoTo", time=50, endurance=endurance, x=x, y=y, z=z, walkType=walkType, closeSlow=closeSlow}
        end
    else
        task = {action="Move", time=70, endurance=endurance, x=x, y=y, z=z, walkType=walkType, closeSlow=closeSlow}
    end
    return task
end

function BanditUtils.CloneIsoPlayer(originalCharacter)
    -- Create a new temporary IsoPlayer at the same position as the original player
    local tempPlayer = IsoPlayer.new(nil, nil, originalCharacter:getX(), originalCharacter:getY(), originalCharacter:getZ())

    -- Copy relevant properties from the original player to the temporary player
    -- tempPlayer:setForname(originalCharacter:getForname())
    -- tempPlayer:setSurname(originalCharacter:getSurname())
    tempPlayer:setGhostMode(true) -- Ensure the temp player is not interactable
    tempPlayer:setGodMod(true)    -- Ensure the temp player cannot die
    tempPlayer:setPrimaryHandItem(originalCharacter:getPrimaryHandItem())
    tempPlayer:setSecondaryHandItem(originalCharacter:getSecondaryHandItem())

    -- You can copy more properties as needed, depending on what you need for the Hit function

    return tempPlayer
end

function BanditUtils.GetNumNearbyBuildings()
    local buildings = BanditUtils.GetNearbyBuildings()
    local buildingCount = 0    
    for _, building in pairs(buildings) do
        buildingCount = buildingCount + 1
    end
    return buildingCount
end

function BanditUtils.GetBuildingID(buildingDef)
    return buildingDef:getX() .. "-" .. buildingDef:getY() .. "-" .. buildingDef:getX2() .. "-" .. buildingDef:getY2()
end

--[[
local x1 = player:getX()
local y1 = player:getY()
local theta = bandit:getDirectionAngle() * math.pi / 180
local r = 5
local x2 = x1 + math.floor(r * math.cos(theta) + 0.5)
local y2 = y1 + math.floor(r * math.sin(theta) + 0.5)
local soundSquare = cell:getGridSquare(x2, y2, 0)
]]

function BanditUtils.findPoint(Ax, Ay, Bx, By, X)
    -- Calculate the direction vector from A to B
    local directionX = Bx - Ax
    local directionY = By - Ay
    
    -- Calculate the length of the direction vector
    local length = math.sqrt(directionX ^ 2 + directionY ^ 2)
    
    -- Normalize the direction vector
    local unitX = directionX / length
    local unitY = directionY / length
    
    -- Scale the unit vector by X units
    local scaledX = unitX * X
    local scaledY = unitY * X
    
    -- Calculate the coordinates of point P
    local Px = Ax + scaledX
    local Py = Ay + scaledY
    
    return Px, Py
end

function BanditUtils.Bresenham(x0, y0, x1, y1)
    local points = {}

    local dx = math.abs(x1 - x0)
    local dy = math.abs(y1 - y0)

    local sx = (x0 < x1) and 1 or -1
    local sy = (y0 < y1) and 1 or -1

    local err = dx - dy

    while true do
        table.insert(points, {x=x0, y=y0})

        if x0 == x1 and y0 == y1 then
            break
        end

        local e2 = 2 * err

        if e2 > -dy then
            err = err - dy
            x0 = x0 + sx
        end

        if e2 < dx then
            err = err + dx
            y0 = y0 + sy
        end
    end

    return points
end

function BanditUtils.IsWater(square)
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local properties = object:getProperties()
        if properties then
            local water = properties:Is(IsoFlagType.water)
            if water then
                return true
            end
        end
    end
    return false
end

function BanditUtils.GetGroundType(square)
    local groundType = "generic"
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if object then
            local sprite = object:getSprite()
            if sprite then
                local spriteName = sprite:getName()
                if spriteName then
                    if spriteName:embodies("street") then
                        groundType = "street"
                    elseif spriteName:embodies("blends_natural") then
                        groundType = "grass"
                    end
                end
            end
        end
    end
    return groundType
end

function BanditUtils.ReplaceDrainable(item)
    local itemType = item:getFullType()
    local newItemType
    if itemType == "farming.WateredCan" then
        newItemType = "farming.WateredCanFull"
    elseif itemType == "Base.BucketEmpty" then
        newItemType = "Base.BucketWaterFull"
    end

    local newItem
    if newItemType then
        newItem = InventoryItemFactory.CreateItem(newItemType)
        newItem:setUsedDelta(0)
    else
        newItem = item
    end
    return newItem
end

function BanditUtils.DistTo(x1, y1, x2, y2)
    -- this is the fastest
    return math.sqrt(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)))

    -- return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))
    -- return IsoUtils.DistanceTo(x1, y1, x2, y2)
end

function BanditUtils.DistToManhattan(x1, y1, x2, y2)
    return math.abs(x1 - x2) + math.abs(y1 - y2)
end

function BanditUtils.Choice(arr)
    local r = 1 + ZombRand(#arr)
    return arr[r]
end

function BanditUtils.CoinFlip()
    if ZombRand(2) == 1 then 
        return true 
    else 
        return false 
    end
end

-- deterministic rand for all clients
function BanditUtils.BanditRand(n)
    local a = 1664525
    local c = 1013904223
    local m = 2^32

    -- this is probably not perfect but
    -- the seed should be same for all clients most of the time
    local gameTime = getGameTime()
    local seed = gameTime:getMinutesStamp()

    seed = (a * seed + c) % m
    return seed % (n + 1)
end
