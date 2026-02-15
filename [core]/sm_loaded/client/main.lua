local isLoading = false
local hasSpawned = false
local spawnPosition = vector4(2507.5876, -384.0722, 94.1201, 267.2562)

-- Spawn manager letiltása
Citizen.CreateThread(function()
    exports.spawnmanager:setAutoSpawn(false)
end)

-- Loading screen megjelenítése
function ShowLoadingScreen(text)
    print('^2[SM_LOADED]^7 Loading screen megjelenítése: ' .. text)
    
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'show',
        text = text
    })
    
    if not IsScreenFadedOut() then
        DoScreenFadeOut(0)
    end
    
    isLoading = true
    
    print('^2[SM_LOADED]^7 Loading screen üzenet elküldve')
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

-- ELŐKÉSZÍTÉS SCREEN MEGJELENÍTÉSE
CreateThread(function()
    -- Várj hogy a resource biztosan betöltődjön
    Wait(1000)
    
    -- Megjelenítjük az Előkészítés screent
    ShowLoadingScreen('Előkészítés')
    
    print('^2[SM_LOADED]^7 Előkészítés screen meghívva')
end)

-- REGISZTRÁLT JÁTÉKOSOK - EVENT ALAPÚ!
RegisterNetEvent('sm_core:onPlayerLoaded', function(playerData)
    print('^2[SM_LOADED]^7 sm_core:onPlayerLoaded event fogadva')
    print('^2[SM_LOADED DEBUG]^7 isRegistered: ' .. tostring(playerData.isRegistered))
    
    -- Várj amíg a loading screen tényleg befejeződik
    while GetIsLoadingScreenActive() do
        Wait(100)
    end
    
    print('^2[SM_LOADED]^7 FiveM loading screen befejezve')
    
    -- CSAK REGISZTRÁLT JÁTÉKOSNAK
    if playerData.isRegistered then
        print('^2[SM_LOADED]^7 Regisztrált játékos spawn folyamat')
        
        local ped = PlayerPedId()
        
        -- Várj amíg a ped létezik
        while not DoesEntityExist(ped) do
            Wait(100)
            ped = PlayerPedId()
        end
        
        print('^2[SM_LOADED]^7 Ped létezik, freeze alkalmazása')
        
        -- Freeze és láthatatlan
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
        SetEntityInvincible(ped, true)
        
        -- Várj a skin betöltésére
        Wait(2000)
        
        print('^2[SM_LOADED]^7 Teleportálás...')
        
        -- Teleportálás
        if SM and SM.PlayerData and SM.PlayerData.lastPosition then
            local pos = SM.PlayerData.lastPosition
            SetEntityCoords(ped, pos.x, pos.y, pos.z, false, false, false, false)
            SetEntityHeading(ped, pos.w or 0.0)
            
            print('^2[SM_LOADED]^7 Spawn pozíció: ' .. pos.x .. ', ' .. pos.y .. ', ' .. pos.z)
        else
            SetEntityCoords(ped, spawnPosition.x, spawnPosition.y, spawnPosition.z, false, false, false, false)
            SetEntityHeading(ped, spawnPosition.w)
            
            print('^2[SM_LOADED]^7 Alapértelmezett spawn pozíció')
        end
        
        Wait(500)
        
        print('^2[SM_LOADED]^7 Unfreeze')
        
        -- Unfreeze
        SetEntityVisible(ped, true, 0)
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        
        Wait(500)
        
        -- Loading screen elrejtése
        HideLoadingScreen()
        
        hasSpawned = true
        
        print('^2[SM_LOADED]^7 Spawn kész!')
        
    else
        -- ÚJ JÁTÉKOS - NE REJTSD EL a loading screent!
        -- Az sm_char majd elrejti amikor kész
        print('^2[SM_LOADED]^7 Új játékos, loading screen MARAD')
        
        -- NE hívd meg a HideLoadingScreen()-t!
        -- Az sm_char fogja kezelni
    end
end)

-- Új event - sm_char hívja amikor kész a teleporttal
RegisterNetEvent('sm_loaded:hideForRegistration', function()
    print('^2[SM_LOADED]^7 Regisztráció kész, loading screen elrejtése')
    
    -- Most már elrejthetjük
    SendNUIMessage({
        action = 'hide'
    })
    
    isLoading = false
    
    -- NE csináljunk fade in-t, az sm_char kezeli!
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