-- Callback regisztráció
function SM.RegisterServerCallback(name, cb)
    SM.ServerCallbacks[name] = cb
end

-- Callback triggerelés
RegisterNetEvent('sm_core:triggerServerCallback', function(name, requestId, ...)
    local src = source
    
    if SM.ServerCallbacks[name] then
        SM.ServerCallbacks[name](src, function(...)
            TriggerClientEvent('sm_core:serverCallback', src, requestId, ...)
        end, ...)
    else
        print('^1[SM_CORE ERROR]^7 Nem létező server callback: ' .. name)
    end
end)

-- Példa callback
SM.RegisterServerCallback('sm_core:getPlayerData', function(source, cb)
    cb(SM.GetPlayer(source))
end)