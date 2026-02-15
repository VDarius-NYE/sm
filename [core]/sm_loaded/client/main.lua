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
    
    -- UI megjelenítés (nincs focus!)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'show',
        text = text
    })
    
    -- Teljes fade out
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
    
    -- Fade in
    if IsScreenFadedOut() then
        DoScreenFadeIn(1000)
    end
end

-- FŐFOLYAMAT - Várj a teljes betöltésre
CreateThread(function()
    -- 1. Várj a hálózatra
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 Hálózat aktív')
    
    -- 2. Várj amíg a játék ténylegesen betölt (fontos!)
    while GetIsLoadingScreenActive() do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 Játék betöltve')
    
    -- 3. Várj az SM.PlayerLoaded-re
    while not SM or not SM.PlayerLoaded do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 PlayerData betöltve, isRegistered: ' .. tostring(SM.PlayerData.isRegistered))
    
    -- 4. Ha REGISZTRÁLT játékos - teleportáld és loading screen
    if SM.PlayerData.isRegistered then
        print('^2[SM_LOADED]^7 Regisztrált játékos spawn folyamat')
        
        -- Loading screen
        ShowLoadingScreen('Karakteradatok betöltése')
        
        local ped = PlayerPedId()
        
        -- Freeze és láthatatlan
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
        SetEntityInvincible(ped, true)
        
        Wait(1000) -- Várj a skin betöltésére
        
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
        -- ÚJ JÁTÉKOS - NE csinálj semmit, hagyj a sm_char-ra
        print('^2[SM_LOADED]^7 Új játékos, várakozás regisztrációra...')
        hasSpawned = false
    end
end)

-- Karakterkészítő után spawn
RegisterNetEvent('sm_loaded:spawnAfterCreation', function()
    print('^2[SM_LOADED]^7 Spawn karakterkészítés után...')
    
    ShowLoadingScreen('Karakter mentése')
    
    Wait(2000) -- Várakozás a mentésre
    
    local ped = PlayerPedId()
    
    -- Freeze közben
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, 0)
    
    -- Teleportálás a spawn pontra
    SetEntityCoords(ped, spawnPosition.x, spawnPosition.y, spawnPosition.z, false, false, false, false)
    SetEntityHeading(ped, spawnPosition.w)
    
    Wait(500)
    
    -- Unfreeze
    SetEntityVisible(ped, true, 0)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    
    Wait(500)
    
    HideLoadingScreen()
    
    hasSpawned = true
end)

-- Regisztráció loading (opcionális)
RegisterNetEvent('sm_loaded:showRegistrationLoading', function()
    print('^2[SM_LOADED]^7 Regisztráció loading...')
    -- NE jelenítsd meg, mert a regisztráció UI-ja van
end)

RegisterNetEvent('sm_loaded:hideRegistrationLoading', function()
    print('^2[SM_LOADED]^7 Regisztráció loading elrejtése')
    -- Semmit ne csinálj
end)