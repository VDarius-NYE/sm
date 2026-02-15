local isRegistering = false
local freezeThread = nil

-- Figyelj az sm_core:onPlayerLoaded eventre
RegisterNetEvent('sm_core:onPlayerLoaded', function(playerData)
    print('^3[SM_CHAR]^7 onPlayerLoaded event fogadva')
    print('^3[SM_CHAR DEBUG]^7 isRegistered: ' .. tostring(playerData.isRegistered))
    
    -- FONTOS: Várj amíg a játék TELJESEN betölt!
    while GetIsLoadingScreenActive() do
        Wait(100)
    end
    
    print('^3[SM_CHAR]^7 Játék teljesen betöltve')
    
    -- FONTOS: Várj amíg a ped TÉNYLEG létezik
    while not DoesEntityExist(PlayerPedId()) do
        Wait(100)
    end
    
    print('^3[SM_CHAR]^7 Ped létezik')
    
    -- Kis extra várakozás
    Wait(1000)
    
    -- Ellenőrizzük hogy regisztrált-e már
    if not playerData.isRegistered then
        print('^2[SM_CHAR]^7 Nincs regisztráció, előkészítés...')
        
        -- Indítsd el a freeze thread-et MOST
        StartFreezeThread()
        
        Wait(500) -- Várj hogy a freeze thread elinduljon
        
        local ped = PlayerPedId()
        
        print('^3[SM_CHAR DEBUG]^7 Ped ID: ' .. ped)
        
        -- Levegőbe a város felett
        local spawnCoords = vector3(215.0, -800.0, 500.0)
        
        -- Teleportálás
        SetEntityCoordsNoOffset(ped, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false)
        SetEntityHeading(ped, 0.0)
        
        print('^3[SM_CHAR]^7 Teleportálva: ' .. spawnCoords.x .. ', ' .. spawnCoords.y .. ', ' .. spawnCoords.z)
        
        Wait(100)
        
        OpenRegistration()
    else
        print('^3[SM_CHAR]^7 Játékos már regisztrált')
    end
end)

-- Freeze thread - folyamatosan freeze-eli a karaktert
function StartFreezeThread()
    if freezeThread then return end
    
    print('^2[SM_CHAR]^7 Freeze thread indítása')
    
    freezeThread = CreateThread(function()
        while isRegistering or not isRegistering do -- Folyamatosan fut amíg nem regisztrált
            local ped = PlayerPedId()
            
            if DoesEntityExist(ped) then
                -- Freeze
                if not IsPedFrozen(ped) then
                    FreezeEntityPosition(ped, true)
                end
                
                -- Láthatatlan
                if IsEntityVisible(ped) then
                    SetEntityVisible(ped, false, 0)
                end
                
                -- Alpha
                if GetEntityAlpha(ped) ~= 0 then
                    SetEntityAlpha(ped, 0, false)
                end
                
                -- Invincible
                if not GetEntityInvincible(ped) then
                    SetEntityInvincible(ped, true)
                end
                
                -- Collision
                SetEntityCollision(ped, false, false)
                
                -- Ragdoll
                SetPedCanRagdoll(ped, false)
            end
            
            Wait(0) -- Minden frame-en fut!
        end
        
        print('^2[SM_CHAR]^7 Freeze thread leállt')
        freezeThread = nil
    end)
end

-- Freeze thread leállítása
function StopFreezeThread()
    isRegistering = false
    
    -- Várj hogy a thread leálljon
    Wait(100)
    
    local ped = PlayerPedId()
    
    if DoesEntityExist(ped) then
        -- Visszaállítás
        FreezeEntityPosition(ped, false)
        SetEntityVisible(ped, true, 0)
        SetEntityAlpha(ped, 255, false)
        SetEntityInvincible(ped, false)
        SetEntityCollision(ped, true, true)
        SetPedCanRagdoll(ped, true)
        
        print('^2[SM_CHAR]^7 Karakter felszabadítva')
    end
end

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
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeRegistration'
    })
    
    -- Állítsd le a freeze thread-et
    StopFreezeThread()
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