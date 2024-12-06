ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Looter = {}
ZombiePrograms.Looter.Stages = {}

ZombiePrograms.Looter.Init = function(bandit)
end

ZombiePrograms.Looter.GetCapabilities = function()
    -- capabilities are program decided
    local capabilities = {}
    capabilities.melee = true
    capabilities.shoot = true
    capabilities.smashWindow = true
    capabilities.openDoor = true
    capabilities.breakDoor = true
    capabilities.breakObjects = true
    capabilities.unbarricade = true
    capabilities.disableGenerators = false
    capabilities.sabotageCars = false
    return capabilities
end

ZombiePrograms.Looter.Prepare = function(bandit)
    local tasks = {}
    local world = getWorld()
    local cell = getCell()
    local cm = world:getClimateManager()
    local dls = cm:getDayLightStrength()

    local weapons = Bandit.GetWeapons(bandit)
    local primary = Bandit.GetBestWeapon(bandit)

    Bandit.ForceStationary(bandit, false)
    Bandit.SetWeapons(bandit, weapons)

    local secondary
    if SandboxVars.Bandits.General_CarryTorches and dls < 0.3 then
        secondary = "Base.HandTorch"
    end

    if weapons.primary.name and weapons.secondary.name then
        local task1 = {action="Unequip", time=100, itemPrimary=weapons.secondary.name}
        table.insert(tasks, task1)
    end

    local task2 = {action="Equip", itemPrimary=primary, itemSecondary=secondary}
    table.insert(tasks, task2)

    return {status=true, next="Operate", tasks=tasks}
end

ZombiePrograms.Looter.Operate = function(bandit)
    local tasks = {}
    local weapons = Bandit.GetWeapons(bandit)

    -- update walk type
    local world = getWorld()
    local cell = getCell()
    local cm = world:getClimateManager()
    local dls = cm:getDayLightStrength()
    local weapons = Bandit.GetWeapons(bandit)
    local outOfAmmo = Bandit.IsOutOfAmmo(bandit)
    local hands = bandit:getVariableString("BanditPrimaryType")
 
    local walkType = "Run"
    if hands == "rifle" or hands =="handgun" then
        walkType = "WalkAim"
    end

    local endurance = 0 -- -0.02
    local secondary
    if dls < 0.3 then
        if SandboxVars.Bandits.General_CarryTorches then
            if hands == "barehand" or hands == "onehanded" or hands == "handgun" then
                secondary = "Base.HandTorch"
            end
        end

        if SandboxVars.Bandits.General_SneakAtNight then
            if Bandit.IsDNA(bandit, "sneak") then
                walkType = "SneakWalk"
                endurance = 0
            end
        end
    end

    local health = bandit:getHealth()
    if health < 0.8 then
        walkType = "Limp"
        endurance = 0
    end 
 
    local handweapon = bandit:getVariableString("BanditWeapon") 
    
    local target = {}
    local enemy
    local closestZombie = BanditUtils.GetClosestZombieLocation(bandit)
    local closestBandit = BanditUtils.GetClosestEnemyBanditLocation(bandit)
    local closestPlayer = BanditUtils.GetClosestPlayerLocation(bandit, true)

    target = closestZombie
    if closestBandit.dist < closestZombie.dist then
        target = closestBandit
        enemy = BanditZombie.GetInstanceById(target.id)
    end

    if Bandit.IsHostile(bandit) and closestPlayer.dist < closestBandit.dist and closestPlayer.dist < closestZombie.dist then
        target = closestPlayer
        enemy = BanditPlayer.GetPlayerById(target.id)
    end

    local closeSlow = true
    if enemy then
        local weapon = enemy:getPrimaryHandItem()
        if weapon and weapon:IsWeapon() then
            local weaponType = WeaponType.getWeaponType(weapon)
            if weaponType == WeaponType.firearm or weaponType == WeaponType.handgun then
                closeSlow = false
            end
        end
    end

    if target.x and target.y and target.z then
        
        local targetSquare = cell:getGridSquare(target.x, target.y, target.z)
        local banditSquare = bandit:getSquare()
        if targetSquare and banditSquare then
            local targetBuilding = targetSquare:getBuilding()
            local banditBuilding = banditSquare:getBuilding()
            local x = 100

            if targetBuilding and not banditBuilding then
                Bandit.Say(bandit, "INSIDE")
            end
            if not targetBuilding and banditBuilding then
                Bandit.Say(bandit, "OUTSIDE")
            end
            if targetBuilding and banditBuilding then
                if bandit:getZ() < target.z then
                    Bandit.Say(bandit, "UPSTAIRS")
                else
                    local room = targetSquare:getRoom()
                    if room then
                        local roomName = room:getName()
                        if roomName == "kitchen" then
                            Bandit.Say(bandit, "ROOM_KITCHEN")
                        end
                        if roomName == "bathroom" then
                            Bandit.Say(bandit, "ROOM_BATHROOM")
                        end
                    end
                end
            end
        end

        -- out of ammo, get close
        local minDist = 2
        if outOfAmmo then
            minDist = 0.5
        end

        if target.dist > minDist then

            -- must be deterministic, not random (same for all clients)
            local id = BanditUtils.GetCharacterID(bandit)

            local dx = 0
            local dy = 0
            local dxf = ((math.abs(id) % 10) - 5) / 10
            local dyf = ((math.abs(id) % 11) - 5) / 10


            table.insert(tasks, BanditUtils.GetMoveTask(endurance, target.x+dx+dxf, target.y+dy+dyf, target.z, walkType, target.dist, closeSlow))
        end
    else
        local task = {action="Time", anim="Shrug", time=200}
        table.insert(tasks, task)
    end

    return {status=true, next="Operate", tasks=tasks}
end

ZombiePrograms.Looter.Wait = function(bandit)
    return {status=true, next="Operate", tasks={}}
end

