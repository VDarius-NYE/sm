local isLoading = false
local spawnPosition = vector4(2507.5876, -384.0722, 94.1201, 267.2562) -- Spawn pozíció karakterkészítés után

-- Spawn manager letiltása
exports.spawnmanager:setAutoSpawn(false)
exports.spawnmanager:forceRespawn()

-- Loading screen megjelenítése
function ShowLoadingScreen(text)
    if isLoading then return end
    
    isLoading = true
    
    print('^2[SM_LOADED]^7 Loading screen megjelenítése: ' .. text)
    
    -- UI megjelenítés
    SetNuiFocus(false, false) -- NE legyen input focus, csak megjelenítés
    SendNUIMessage({
        action = 'show',
        text = text
    })
    
    -- Freeze player
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, 0)
    
    -- Teljes fade out
    DoScreenFadeOut(0)
end

-- Loading screen elrejtése
function HideLoadingScreen()
    if not isLoading then return end
    
    print('^2[SM_LOADED]^7 Loading screen elrejtése')
    
    SendNUIMessage({
        action = 'hide'
    })
    
    -- Unfreeze player
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, 0)
    
    -- Fade in
    DoScreenFadeIn(1000)
    
    isLoading = false
end

-- Első spawn kezelés
CreateThread(function()
    -- Várj amíg a hálózat aktív
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 Hálózat aktív, loading screen indítása...')
    
    -- Azonnal teleportáld magasra (láthatatlanul)
    local ped = PlayerPedId()
    local highPosition = vector3(2507.5876, -384.0722, 500.0) -- Magasan a spawn pozíció felett
    
    SetEntityCoords(ped, highPosition.x, highPosition.y, highPosition.z)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, 0)
    SetEntityInvincible(ped, true)
    
    -- Loading screen megjelenítése
    ShowLoadingScreen('Karakteradatok betöltése')
    
    -- Várj az SM.PlayerData betöltésére
    while not SM or not SM.PlayerLoaded do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 PlayerData betöltve')
    
    -- Ha regisztrált játékos
    if SM.PlayerData.isRegistered then
        print('^2[SM_LOADED]^7 Regisztrált játékos, spawn pozíció betöltése...')
        
        Wait(1000) -- Kis extra várakozás a skin betöltésére
        
        -- Teleportálás az utolsó pozícióra
        if SM.PlayerData.lastPosition then
            local pos = SM.PlayerData.lastPosition
            SetEntityCoords(ped, pos.x, pos.y, pos.z)
            SetEntityHeading(ped, pos.w or 0.0)
            
            print('^2[SM_LOADED]^7 Spawn pozíció: ' .. pos.x .. ', ' .. pos.y .. ', ' .. pos.z)
        else
            -- Ha nincs mentett pozíció, spawn pont
            SetEntityCoords(ped, spawnPosition.x, spawnPosition.y, spawnPosition.z)
            SetEntityHeading(ped, spawnPosition.w)
            
            print('^2[SM_LOADED]^7 Alapértelmezett spawn pozíció')
        end
        
        SetEntityInvincible(ped, false)
        
        Wait(500)
        
        -- Loading screen elrejtése
        HideLoadingScreen()
    else
        -- Új játékos - a regisztráció és karakterkészítő kezeli
        print('^2[SM_LOADED]^7 Új játékos, regisztráció folyamat...')
        
        -- Elrejtjük a loading screent, mert jön a regisztráció
        SendNUIMessage({
            action = 'hide'
        })
        
        isLoading = false
    end
end)

-- Karakterkészítő után spawn
RegisterNetEvent('sm_loaded:spawnAfterCreation', function()
    print('^2[SM_LOADED]^7 Spawn karakterkészítés után...')
    
    ShowLoadingScreen('Karakter mentése')
    
    Wait(2000) -- Várakozás a mentésre
    
    local ped = PlayerPedId()
    
    -- Teleportálás a spawn pontra
    SetEntityCoords(ped, spawnPosition.x, spawnPosition.y, spawnPosition.z)
    SetEntityHeading(ped, spawnPosition.w)
    SetEntityInvincible(ped, false)
    
    Wait(500)
    
    HideLoadingScreen()
end)

-- Regisztráció után loading
RegisterNetEvent('sm_loaded:showRegistrationLoading', function()
    print('^2[SM_LOADED]^7 Regisztráció loading...')
    ShowLoadingScreen('Karakter regisztrálása')
end)

RegisterNetEvent('sm_loaded:hideRegistrationLoading', function()
    print('^2[SM_LOADED]^7 Regisztráció loading elrejtése')
    SendNUIMessage({
        action = 'hide'
    })
    isLoading = false
end)