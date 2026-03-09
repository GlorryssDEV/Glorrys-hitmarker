AddEventHandler("gameEventTriggered", function(ev,data)

    if ev ~= "CEventNetworkEntityDamage" then return end

    local victim = data[1]
    local attacker = data[2]

    if attacker ~= PlayerPedId() then return end
    if not IsEntityAPed(victim) then return end

    local raw = data[3]
    local dmg = math.floor(string.unpack("f", string.pack("i4", raw)))
    if dmg <= 0 then return end

    local headshot = false
    local bone = 31086

    local success,lastBone = GetPedLastDamageBone(victim)

    if success then
        bone = lastBone
        if bone == 31086 then
            headshot = true
        end
    end

    local coords = GetPedBoneCoords(victim,bone)
    local onScreen,x,y = World3dToScreen2d(coords.x,coords.y,coords.z)

    if not onScreen then return end

    local color = Glorrys.TextColorHP

    if headshot then
        color = Glorrys.TextColorHeadshot
    elseif GetPedArmour(victim) > 0 then
        color = Glorrys.TextColorArmour
    end

    SendNUIMessage({
        action = "hit",
        damage = dmg,
        headshot = headshot,
        x = x,
        y = y,
        color = color,
        size = Glorrys.TextSize,
        headsize = Glorrys.HeadshotSize,
        duration = Glorrys.Duration
    })

end)

local testNpc = nil
local testNpc2 = nil

RegisterCommand("npc", function()

    if testNpc and testNpc2 and DoesEntityExist(testNpc) and DoesEntityExist(testNpc2) then
        DeleteEntity(testNpc)
        DeleteEntity(testNpc2)
    end

    local player = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(player,0.0,5.0,0.0)
    local coords2 = GetOffsetFromEntityInWorldCoords(player,1.0,5.0,0.0)
    local heading = GetEntityHeading(player)

    local model = `a_m_m_skater_01`

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    testNpc = CreatePed(4,model,coords.x,coords.y,coords.z,heading,true,true)
    testNpc2 = CreatePed(4,model,coords2.x,coords2.y,coords2.z,heading,true,true)

    SetEntityHealth(testNpc,100)
    SetPedArmour(testNpc,500)
    SetEntityHealth(testNpc2,500)
    SetPedArmour(testNpc2,0)

    SetBlockingOfNonTemporaryEvents(testNpc,true)
    TaskStandStill(testNpc,-1)
    FreezeEntityPosition(testNpc,true)
    SetBlockingOfNonTemporaryEvents(testNpc2,true)
    TaskStandStill(testNpc2,-1)
    FreezeEntityPosition(testNpc2,true)

end)
