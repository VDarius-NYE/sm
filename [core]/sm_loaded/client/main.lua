local isLoading = false
local hasSpawned = false
local spawnPosition = vector4(2507.5876, -384.0722, 94.1201, 267.2562)

-- Spawn manager letiltása
Citizen.CreateThread(function()
    exports.spawnmanager:setAutoSpawn(false)
end)

-- Loading screen megjelenítése
function ShowLoadingScreen(text)
    if isLoading then return end
    
    isLoading = true
    
    print('^2[SM_LOADED]^7 Loading screen megjelenítése: ' .. text)
    
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'show',
        text = text
    })
    
    if not IsScreenFadedOut() then
        DoScreenFadeOut(500)
        Wait(500)
    end
end

-- Loading screen elrejtése
function HideLoadingScreen()
    if not isLoading then return end
    
    print('^2[SM_LOADED]^7 Loading screen elrejtése')
    
    SendNUIMessage({
        action = 'hide'
    })
    
    isLoading = false
    
    if IsScreenFadedOut() then
        DoScreenFadeIn(1000)
    end
end

-- REGISZTRÁLT JÁTÉKOSOK SPAWN FOLYAMATA
CreateThread(function()
    -- 1. Várj a hálózatra
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 Hálózat aktív')
    
    -- 2. Várj amíg a játék HIVATALOSAN betölt (FiveM loading screen)
    while GetIsLoadingScreenActive() do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 Játék hivatalosan betöltve')
    
    -- 3. Várj az SM.PlayerLoaded-re
    while not SM or not SM.PlayerLoaded do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 PlayerData betöltve, isRegistered: ' .. tostring(SM.PlayerData.isRegistered))
    
    -- 4. CSAK REGISZTRÁLT JÁTÉKOSNAK
    if SM.PlayerData.isRegistered then
        print('^2[SM_LOADED]^7 Regisztrált játékos spawn folyamat')
        
        -- Loading screen ELŐKÉSZÍTÉS szöveggel
        ShowLoadingScreen('Előkészítés')
        
        local ped = PlayerPedId()
        
        -- Várj amíg a ped létezik
        while not DoesEntityExist(ped) do
            Wait(100)
            ped = PlayerPedId()
        end
        
        -- Freeze és láthatatlan
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
        SetEntityInvincible(ped, true)
        
        -- Várj a skin betöltésére (sm_core alkalmazza)
        Wait(1500)
        
        -- Teleportálás az utolsó pozícióra
        if SM.PlayerData.lastPosition then
            local pos = SM.PlayerData.lastPosition
            SetEntityCoords(ped, pos.x, pos.y, pos.z, false, false, false, false)
            SetEntityHeading(ped, pos.w or 0.0)
            
            print('^2[SM_LOADED]^7 Spawn pozíció: ' .. pos.x .. ', ' .. pos.y .. ', ' .. pos.z)
        else
            -- Ha nincs mentett pozíció
            SetEntityCoords(ped, spawnPosition.x, spawnPosition.y, spawnPosition.z, false, false, false, false)
            SetEntityHeading(ped, spawnPosition.w)
            
            print('^2[SM_LOADED]^7 Alapértelmezett spawn pozíció')
        end
        
        Wait(500)
        
        -- Unfreeze
        SetEntityVisible(ped, true, 0)
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        
        Wait(500)
        
        -- Loading screen elrejtése
        HideLoadingScreen()
        
        hasSpawned = true
        
    else
        -- ÚJ JÁTÉKOS - nincs spawn, hagyj a sm_char-ra
        print('^2[SM_LOADED]^7 Új játékos, nincs spawn folyamat')
    end
end)

-- Karakterkészítő után spawn
RegisterNetEvent('sm_loaded:spawnAfterCreation', function()
    print('^2[SM_LOADED]^7 Spawn karakterkészítés után...')
    
    ShowLoadingScreen('Karakter mentése')
    
    Wait(2000)
    
    local ped = PlayerPedId()
    
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, 0)
    
    SetEntityCoords(ped, spawnPosition.x, spawnPosition.y, spawnPosition.z, false, false, false, false)
    SetEntityHeading(ped, spawnPosition.w)
    
    Wait(500)
    
    SetEntityVisible(ped, true, 0)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    
    Wait(500)
    
    HideLoadingScreen()
    
    hasSpawned = true
end)

-- Általános loading
RegisterNetEvent('sm_loaded:showLoading', function(text)
    ShowLoadingScreen(text or 'Betöltés')
end)

RegisterNetEvent('sm_loaded:hideLoading', function()
    HideLoadingScreen()
end)