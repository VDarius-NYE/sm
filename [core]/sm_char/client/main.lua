local isRegistering = false

-- Figyelj az sm_core:onPlayerLoaded eventre
RegisterNetEvent('sm_core:onPlayerLoaded', function(playerData)
    print('^3[SM_CHAR]^7 onPlayerLoaded event fogadva')
    print('^3[SM_CHAR DEBUG]^7 isRegistered: ' .. tostring(playerData.isRegistered))
    
    -- FONTOS: Várj amíg a játék TELJESEN betölt!
    while GetIsLoadingScreenActive() do
        Wait(100)
    end
    
    print('^3[SM_CHAR]^7 Játék teljesen betöltve')
    
    -- Kis extra várakozás
    Wait(500)
    
    -- Ellenőrizzük hogy regisztrált-e már
    if not playerData.isRegistered then
        print('^2[SM_CHAR]^7 Nincs regisztráció, előkészítés...')
        
        local ped = PlayerPedId()
        
        -- ELŐSZÖR freeze és láthatatlan
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
        SetEntityInvincible(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityAlpha(ped, 0, false)
        
        Wait(100) -- Várj hogy az állapotok alkalmazzák
        
        -- Levegőbe a város felett - SZÉP KILÁTÁS!
        local spawnCoords = vector3(215.0, -800.0, 500.0)
        
        -- Teleportálás
        SetEntityCoordsNoOffset(ped, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false)
        SetEntityHeading(ped, 0.0)
        
        -- Még egyszer alkalmazd a freeze-t és invisible-t (biztosra megy)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
        SetEntityInvincible(ped, true)
        SetEntityCollision(ped, false, false)
        
        -- Ragdoll kikapcsolása
        SetPedCanRagdoll(ped, false)
        SetPedCanBeKnockedOffVehicle(ped, 1)
        
        -- Ellenőrzés thread - hogy biztosan freeze maradjon
        CreateThread(function()
            while isRegistering do
                local playerPed = PlayerPedId()
                
                -- Ha nem freeze-lt, freeze-ld újra
                if not IsPedFrozen(playerPed) then
                    FreezeEntityPosition(playerPed, true)
                end
                
                -- Ha látszik, rejtsd el újra
                if IsEntityVisible(playerPed) then
                    SetEntityVisible(playerPed, false, 0)
                    SetEntityAlpha(playerPed, 0, false)
                end
                
                Wait(100)
            end
        end)
        
        Wait(100)
        
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
    
    -- Unfreeze és láthatóvá tétel (charakterkészítő majd beállítja)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, 0)
    SetEntityAlpha(ped, 255, false)
    SetPedCanRagdoll(ped, true)
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
    
    -- Várj hogy az SM.PlayerData frissüljön
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