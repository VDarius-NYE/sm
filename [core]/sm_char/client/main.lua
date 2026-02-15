local isRegistering = false

-- Figyelj az sm_core:onPlayerLoaded eventre
RegisterNetEvent('sm_core:onPlayerLoaded', function(playerData)
    print('^3[SM_CHAR]^7 onPlayerLoaded event fogadva')
    print('^3[SM_CHAR DEBUG]^7 isRegistered: ' .. tostring(playerData.isRegistered))
    
    -- Ellenőrizzük hogy regisztrált-e már
    if not playerData.isRegistered then
        print('^2[SM_CHAR]^7 Nincs regisztráció, előkészítés...')
        
        -- Azonnal teleportáld és fagyaszd le
        local ped = PlayerPedId()
        
        -- Levegőbe a város felett (Legion Square felett magasan)
        local spawnCoords = vector3(215.0, -800.0, 500.0)
        
        DoScreenFadeOut(0) -- Azonnali fade out
        
        SetEntityCoords(ped, spawnCoords.x, spawnCoords.y, spawnCoords.z)
        SetEntityHeading(ped, 0.0)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
        SetEntityInvincible(ped, true)
        
        Wait(100) -- Rövid várakozás a pozíció beállására
        
        OpenRegistration()
    else
        print('^3[SM_CHAR]^7 Játékos már regisztrált')
    end
end)

-- Regisztrációs UI megnyitása
function OpenRegistration()
    if isRegistering then 
        print('^3[SM_CHAR]^7 Már regisztrál...')
        return 
    end
    
    print('^2[SM_CHAR]^7 OpenRegistration() meghívva')
    
    isRegistering = true
    
    -- UI megjelenítés
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openRegistration'
    })
    
    print('^2[SM_CHAR]^7 NUI üzenet elküldve: openRegistration')
end

-- Regisztrációs UI bezárása
function CloseRegistration()
    isRegistering = false
    
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeRegistration'
    })
end

-- NUI Callback - Regisztráció
RegisterNUICallback('registerCharacter', function(data, cb)
    print('^2[SM_CHAR]^7 Regisztráció küldése...')
    TriggerServerEvent('sm_char:registerCharacter', data)
    cb('ok')
end)

-- Sikeres regisztráció
RegisterNetEvent('sm_char:registrationSuccess', function()
    print('^2[SM_CHAR]^7 Regisztráció sikeres!')
    CloseRegistration()
    
    -- JAVÍTÁS: Várj hogy az SM.PlayerData frissüljön
    Wait(2000)
    
    -- Ellenőrizd hogy létezik-e
    if SM and SM.PlayerData then
        SM.PlayerData.isRegistered = true
        print('^2[SM_CHAR]^7 PlayerData frissítve')
    else
        print('^1[SM_CHAR ERROR]^7 SM.PlayerData nem elérhető!')
    end
    
    -- Karakterkészítő megnyitása
    print('^2[SM_CHAR]^7 Karakterkészítő trigger...')
    TriggerEvent('sm_charcreation:open')
end)

-- Hiba üzenet
RegisterNetEvent('sm_char:registrationError', function(message)
    print('^1[SM_CHAR ERROR]^7 ' .. message)
    SendNUIMessage({
        action = 'showError',
        message = message
    })
end)