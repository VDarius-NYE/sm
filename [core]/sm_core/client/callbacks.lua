SM.CurrentRequestId = 0
SM.ServerCallbacks = {}

-- Server callback hívás
function SM.TriggerServerCallback(name, cb, ...)
    SM.ServerCallbacks[SM.CurrentRequestId] = cb
    
    TriggerServerEvent('sm_core:triggerServerCallback', name, SM.CurrentRequestId, ...)
    
    SM.CurrentRequestId = SM.CurrentRequestId + 1
end

-- Callback fogadása
RegisterNetEvent('sm_core:serverCallback', function(requestId, ...)
    if SM.ServerCallbacks[requestId] then
        SM.ServerCallbacks[requestId](...)
        SM.ServerCallbacks[requestId] = nil
    end
end)