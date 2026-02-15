-- Játékos betöltése
function SM.LoadPlayer(source, identifier)
    local result = MySQL.query.await('SELECT * FROM sm_players WHERE identifier = ?', {identifier})
    
    if result and result[1] then
        -- Létező játékos
        local playerData = result[1]
        
        -- KRITIKUS JAVÍTÁS: is_registered ellenőrzés
        -- MySQL néha boolean-ként, néha számként adja vissza
        local isReg = false
        
        if playerData.is_registered == 1 or playerData.is_registered == true or playerData.is_registered == '1' then
            isReg = true
        else
            isReg = false
        end
        
        SM.Players[source] = {
            source = source,
            identifier = identifier,
            name = GetPlayerName(source),
            firstname = playerData.firstname,
            lastname = playerData.lastname,
            dateofbirth = playerData.dateofbirth,
            gender = playerData.gender,
            height = playerData.height,
            skin = playerData.skin and json.decode(playerData.skin) or nil,
            isRegistered = isReg,
            rank = playerData.rank,
            team = playerData.team,
            money = playerData.money,
            bank = playerData.bank,
            kills = playerData.kills,
            deaths = playerData.deaths,
            playtime = playerData.playtime,
            permission = playerData.permission,
            lastPosition = playerData.last_position and json.decode(playerData.last_position) or SM.Config.DefaultSpawn
        }
        
        print('^3[SM_CORE DEBUG]^7 DB érték: ' .. tostring(playerData.is_registered) .. ' (típus: ' .. type(playerData.is_registered) .. ')')
        print('^3[SM_CORE DEBUG]^7 Konvertált: ' .. tostring(isReg))
        
        if SM.Config.Debug then
            print('^2[SM_CORE]^7 Játékos betöltve: ' .. GetPlayerName(source) .. ' (ID: ' .. playerData.id .. ')')
        end
        
        -- Kliens értesítése
        Wait(500)
        TriggerClientEvent('sm_core:setPlayerData', source, SM.Players[source])
        
    else
        -- Új játékos
        MySQL.insert('INSERT INTO sm_players (identifier, name, rank, money, permission, is_registered) VALUES (?, ?, ?, ?, ?, ?)', {
            identifier,
            GetPlayerName(source),
            SM.Config.Player.StartingRank,
            SM.Config.Player.StartingMoney,
            'user',
            0
        }, function(id)
            SM.Players[source] = {
                source = source,
                identifier = identifier,
                name = GetPlayerName(source),
                firstname = nil,
                lastname = nil,
                dateofbirth = nil,
                gender = 'm',
                height = 175,
                skin = nil,
                isRegistered = false,
                rank = SM.Config.Player.StartingRank,
                team = nil,
                money = SM.Config.Player.StartingMoney,
                bank = 0,
                kills = 0,
                deaths = 0,
                playtime = 0,
                permission = 'user',
                lastPosition = SM.Config.DefaultSpawn
            }
            
            print('^2[SM_CORE]^7 Új játékos létrehozva: ' .. GetPlayerName(source) .. ' (ID: ' .. id .. ')')
            
            -- Kliens értesítése
            Wait(500)
            TriggerClientEvent('sm_core:setPlayerData', source, SM.Players[source])
        end)
    end
end

-- Játékos mentése
function SM.SavePlayer(source)
    local player = SM.Players[source]
    if not player then return end
    TriggerClientEvent('sm_core:requestPosition', source)
    Wait(100)
    
    MySQL.update('UPDATE sm_players SET name = ?, firstname = ?, lastname = ?, dateofbirth = ?, gender = ?, height = ?, skin = ?, is_registered = ?, rank = ?, team = ?, money = ?, bank = ?, kills = ?, deaths = ?, playtime = ?, permission = ?, last_position = ? WHERE identifier = ?', {
        player.name,
        player.firstname,
        player.lastname,
        player.dateofbirth,
        player.gender,
        player.height,
        player.skin and json.encode(player.skin) or nil,
        player.isRegistered,
        player.rank,
        player.team,
        player.money,
        player.bank,
        player.kills,
        player.deaths,
        player.playtime,
        player.permission,
        json.encode(player.lastPosition),
        player.identifier
    })
    
    if SM.Config.Debug then
        print('^3[SM_CORE]^7 Játékos mentve: ' .. player.name)
    end
end

-- Játékos lekérése
function SM.GetPlayer(source)
    return SM.Players[source]
end

-- Játékos lekérése identifier alapján
function SM.GetPlayerFromIdentifier(identifier)
    for _, player in pairs(SM.Players) do
        if player.identifier == identifier then
            return player
        end
    end
    return nil
end