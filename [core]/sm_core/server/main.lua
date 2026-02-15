SM.Players = {}
SM.ServerCallbacks = {}

-- Szerver indulás
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('^2[SM_CORE]^7 SilverMilitary Core elindult!')
    
    -- Adatbázis táblák létrehozása
    CreateDatabaseTables()
end)

-- Játékos csatlakozás
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local identifier = SM.GetIdentifier(src)
    
    deferrals.defer()
    
    Wait(0)
    deferrals.update('Üdvözlünk a SilverMilitary szerveren! Adatok betöltése...')
    
    if not identifier then
        deferrals.done('Nem található Steam/License azonosító!')
        return
    end
    
    Wait(100)
    deferrals.done()
end)

-- Játékos betöltődött
RegisterNetEvent('sm_core:playerLoaded', function()
    local src = source
    local identifier = SM.GetIdentifier(src)
    
    if not identifier then
        DropPlayer(src, 'Nem található azonosító!')
        return
    end
    
    SM.LoadPlayer(src, identifier)
end)

-- Játékos kilépés
AddEventHandler('playerDropped', function(reason)
    local src = source
    
    if SM.Players[src] then
        SM.SavePlayer(src)
        SM.Players[src] = nil
        
        if SM.Config.Debug then
            print('^3[SM_CORE]^7 Játékos kilépett: ' .. GetPlayerName(src) .. ' (' .. reason .. ')')
        end
    end
end)

-- Autosave
CreateThread(function()
    while true do
        Wait(SM.Config.Player.SaveInterval)
        
        local savedCount = 0
        for playerId, _ in pairs(SM.Players) do
            SM.SavePlayer(playerId)
            savedCount = savedCount + 1
        end
        
        if SM.Config.Debug and savedCount > 0 then
            print('^2[SM_CORE]^7 Automatikus mentés: ' .. savedCount .. ' játékos')
        end
    end
end)

-- Pozíció mentése
RegisterNetEvent('sm_core:savePosition', function(position)
    local src = source
    local player = SM.Players[src]
    
    if player then
        player.lastPosition = position
        print('^3[SM_CORE]^7 Pozíció mentve: ' .. position.x .. ', ' .. position.y .. ', ' .. position.z)
    end
end)

-- Adatbázis táblák
function CreateDatabaseTables()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `sm_players` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `identifier` VARCHAR(60) UNIQUE NOT NULL,
            `name` VARCHAR(100) NOT NULL,
            `firstname` VARCHAR(50) DEFAULT NULL,
            `lastname` VARCHAR(50) DEFAULT NULL,
            `dateofbirth` VARCHAR(10) DEFAULT NULL,
            `gender` VARCHAR(1) DEFAULT 'm',
            `height` INT DEFAULT 175,
            `skin` LONGTEXT DEFAULT NULL,
            `is_registered` BOOLEAN DEFAULT FALSE,
            `rank` VARCHAR(50) DEFAULT 'recruit',
            `team` VARCHAR(50) DEFAULT NULL,
            `money` INT DEFAULT 0,
            `bank` INT DEFAULT 0,
            `kills` INT DEFAULT 0,
            `deaths` INT DEFAULT 0,
            `playtime` INT DEFAULT 0,
            `permission` VARCHAR(50) DEFAULT 'user',
            `last_position` TEXT DEFAULT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            `last_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX `idx_identifier` (`identifier`),
            INDEX `idx_name` (`name`),
            INDEX `idx_rank` (`rank`),
            INDEX `idx_team` (`team`),
            INDEX `idx_registered` (`is_registered`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    
    if SM.Config.Debug then
        print('^2[SM_CORE]^7 Adatbázis táblák létrehozva/ellenőrizve')
    end
end

-- Karakter adatok beállítása (sm_char-ból hívva)
RegisterNetEvent('sm_core:setCharacterData', function(source, data)
    local player = SM.Players[source]
    
    if not player then
        print('^1[SM_CORE ERROR]^7 Nem található játékos: ' .. source)
        return
    end
    
    -- Adatok beállítása
    if data.firstname then player.firstname = data.firstname end
    if data.lastname then player.lastname = data.lastname end
    if data.dateofbirth then player.dateofbirth = data.dateofbirth end
    if data.gender then player.gender = data.gender end
    if data.height then player.height = data.height end
    
    player.isRegistered = true
    
    -- Mentés
    SM.SavePlayer(source)
    
    -- Kliens frissítés
    TriggerClientEvent('sm_core:setPlayerData', source, player)
    
    print('^2[SM_CORE]^7 Karakter adatok mentve: ' .. player.firstname .. ' ' .. player.lastname)
end)