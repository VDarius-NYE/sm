--SM.PlayerData = {}
--SM.PlayerLoaded = false

-- Resource indulás
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    
    print('^3[SM_CORE CLIENT]^7 Hálózat aktív, playerLoaded trigger...')
    TriggerServerEvent('sm_core:playerLoaded')
end)

-- Játékos adat fogadása
RegisterNetEvent('sm_core:setPlayerData', function(data)
    SM.PlayerData = data
    SM.PlayerLoaded = true
    
    print('^2[SM_CORE]^7 Játékos adatok betöltve')
    print('^3[SM_CORE DEBUG]^7 SM.PlayerLoaded = ' .. tostring(SM.PlayerLoaded))
    print('^3[SM_CORE DEBUG]^7 isRegistered = ' .. tostring(SM.PlayerData.isRegistered))
    
    -- SPAWN KEZELÉS
    if data.isRegistered then
        -- Regisztrált játékos - alkalmazzuk a mentett skint
        print('^2[SM_CORE]^7 Regisztrált játékos, skin alkalmazása...')
        
        -- Spawn pozíció
        if data.lastPosition then
            SetEntityCoords(PlayerPedId(), data.lastPosition.x, data.lastPosition.y, data.lastPosition.z)
            SetEntityHeading(PlayerPedId(), data.lastPosition.w or 0.0)
        end
        
        -- Ha van mentett skin
        if data.skin and data.skin.skin then
            -- Betöltjük a freemode modelt
            local gender = data.gender or 'm'
            local model = gender == 'm' and 'mp_m_freemode_01' or 'mp_f_freemode_01'
            
            RequestModel(GetHashKey(model))
            while not HasModelLoaded(GetHashKey(model)) do
                Wait(0)
            end
            
            SetPlayerModel(PlayerId(), GetHashKey(model))
            SetPedDefaultComponentVariation(PlayerPedId())
            
            -- Várj egy kicsit majd alkalmazzuk a skint
            Wait(500)
            TriggerEvent('sm_core:applySavedSkin', data.skin)
        end
    else
        -- Új játékos - NORMÁL PED marad!
        print('^2[SM_CORE]^7 Új játékos, alapértelmezett ped megtartása')
        -- NE változtasd meg a modelt, maradjon michael/franklin/trevor
    end
    
    TriggerEvent('sm_core:onPlayerLoaded', data)
end)

-- Mentett skin alkalmazása event
RegisterNetEvent('sm_core:applySavedSkin', function(skinData)
    if not skinData or not skinData.skin then return end
    
    print('^2[SM_CORE]^7 Mentett skin alkalmazása...')
    
    -- Itt hívd meg a skin alkalmazó függvényt
    TriggerEvent('sm_charcreation:applySkin', skinData.skin, skinData.clothes)
end)

-- Adat frissítés
RegisterNetEvent('sm_core:updatePlayerData', function(key, value)
    if SM.PlayerData[key] ~= nil then
        SM.PlayerData[key] = value
        print('^3[SM_CORE]^7 PlayerData frissítve: ' .. key .. ' = ' .. tostring(value))
    end
end)

-- Pozíció küldése a szervernek
RegisterNetEvent('sm_core:requestPosition', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    SM.PlayerData.lastPosition = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        w = heading
    }
end)