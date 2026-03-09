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
