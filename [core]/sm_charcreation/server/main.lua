local SM = exports.sm_core

-- Skin mentése
RegisterNetEvent('sm_charcreation:saveSkin', function(data)
    local src = source
    local player = SM:GetPlayer(src)
    
    if not player then
        print('^1[SM_CHARCREATION ERROR]^7 Nem található játékos: ' .. src)
        return
    end
    
    -- Skin és clothes együttes mentése
    local skinData = {
        skin = data.skin,
        clothes = data.clothes
    }
    
    SM:SetSkin(src, skinData)
    SM:SavePlayer(src)
    
    print('^2[SM_CHARCREATION]^7 Skin mentve: ' .. GetPlayerName(src))
    
    TriggerClientEvent('sm_charcreation:skinSaved', src)
end)

-- Skin betöltése
RegisterNetEvent('sm_charcreation:getSkin', function()
    local src = source
    local player = SM.GetPlayer(src)
    
    if player and player.skin then
        TriggerClientEvent('sm_charcreation:receiveSkin', src, player.skin)
    else
        TriggerClientEvent('sm_charcreation:receiveSkin', src, nil)
    end
end)