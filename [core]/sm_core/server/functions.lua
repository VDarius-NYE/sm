-- Identifier lekérése
function SM.GetIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    
    for _, id in pairs(identifiers) do
        if string.match(id, 'license:') then
            return id
        end
    end
    
    -- Ha nincs license, próbáljuk steam-et
    for _, id in pairs(identifiers) do
        if string.match(id, 'steam:') then
            return id
        end
    end
    
    return nil
end

-- Karakter adatok beállítása
function SM.SetCharacterData(source, data)
    local player = SM.GetPlayer(source)
    if not player then return false end
    
    if data.firstname then player.firstname = data.firstname end
    if data.lastname then player.lastname = data.lastname end
    if data.dateofbirth then player.dateofbirth = data.dateofbirth end
    if data.gender then player.gender = data.gender end
    if data.height then player.height = data.height end
    
    player.isRegistered = true
    
    TriggerClientEvent('sm_core:updatePlayerData', source, 'isRegistered', true)
    
    return true
end

-- Skin mentése
function SM.SetSkin(source, skin)
    local player = SM.GetPlayer(source)
    if not player then return false end
    
    player.skin = skin
    
    return true
end

-- Skin lekérése
function SM.GetSkin(source)
    local player = SM.GetPlayer(source)
    return player and player.skin or nil
end

-- Regisztráció ellenőrzés
function SM.IsPlayerRegistered(source)
    local player = SM.GetPlayer(source)
    return player and player.isRegistered or false
end

-- Pénz hozzáadás
function SM.AddMoney(source, amount)
    local player = SM.GetPlayer(source)
    if not player then return false end
    
    player.money = player.money + amount
    TriggerClientEvent('sm_core:updatePlayerData', source, 'money', player.money)
    
    return true
end

-- Pénz elvétel
function SM.RemoveMoney(source, amount)
    local player = SM.GetPlayer(source)
    if not player or player.money < amount then return false end
    
    player.money = player.money - amount
    TriggerClientEvent('sm_core:updatePlayerData', source, 'money', player.money)
    
    return true
end

-- Pénz lekérdezés
function SM.GetMoney(source)
    local player = SM.GetPlayer(source)
    return player and player.money or 0
end

-- Rang beállítás
function SM.SetRank(source, rank)
    local player = SM.GetPlayer(source)
    if not player or not SM.Shared.Ranks[rank] then return false end
    
    player.rank = rank
    TriggerClientEvent('sm_core:updatePlayerData', source, 'rank', rank)
    
    return true
end

-- Csapat beállítás
function SM.SetTeam(source, team)
    local player = SM.GetPlayer(source)
    if not player or (team and not SM.Shared.Teams[team]) then return false end
    
    player.team = team
    TriggerClientEvent('sm_core:updatePlayerData', source, 'team', team)
    
    return true
end

-- Engedély ellenőrzés
function SM.HasPermission(source, requiredPermission)
    local player = SM.GetPlayer(source)
    if not player then return false end
    
    local playerPermLevel = SM.Config.Permissions[player.permission] or 0
    local requiredPermLevel = SM.Config.Permissions[requiredPermission] or 0
    
    return playerPermLevel >= requiredPermLevel
end

-- Kill hozzáadás
function SM.AddKill(source)
    local player = SM.GetPlayer(source)
    if not player then return end
    
    player.kills = player.kills + 1
    TriggerClientEvent('sm_core:updatePlayerData', source, 'kills', player.kills)
end

-- Death hozzáadás
function SM.AddDeath(source)
    local player = SM.GetPlayer(source)
    if not player then return end
    
    player.deaths = player.deaths + 1
    TriggerClientEvent('sm_core:updatePlayerData', source, 'deaths', player.deaths)
end

-- Összes online játékos
function SM.GetPlayers()
    return SM.Players
end

-- Exportok
exports('GetPlayer', SM.GetPlayer)
exports('GetPlayers', SM.GetPlayers)
exports('SetSkin', SM.SetSkin)
exports('GetSkin', SM.GetSkin)
exports('SetCharacterData', SM.SetCharacterData)
exports('SavePlayer', SM.SavePlayer)
exports('RegisterServerCallback', SM.RegisterServerCallback)