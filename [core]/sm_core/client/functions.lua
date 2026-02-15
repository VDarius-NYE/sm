-- Játékos koordináták
function SM.GetPlayerCoords()
    return GetEntityCoords(PlayerPedId())
end

-- Játékos heading
function SM.GetPlayerHeading()
    return GetEntityHeading(PlayerPedId())
end

-- Közelben lévő játékosok
function SM.GetPlayersInArea(coords, maxDistance)
    local players = {}
    local ped = PlayerPedId()
    local myCoords = coords or GetEntityCoords(ped)
    
    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= ped then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(myCoords - targetCoords)
            
            if distance <= maxDistance then
                table.insert(players, {
                    playerId = player,
                    ped = targetPed,
                    coords = targetCoords,
                    distance = distance
                })
            end
        end
    end
    
    return players
end

-- Jármű lekérdezés
function SM.GetVehicle()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        return GetVehiclePedIsIn(ped, false)
    end
    return nil
end

-- Értesítés
function SM.Notify(message, type, duration)
    -- Ezt később kibővítheted custom UI-val
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end