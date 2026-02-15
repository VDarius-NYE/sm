-- Karakter regisztráció
RegisterNetEvent('sm_char:registerCharacter', function(data)
    local src = source
    
    -- Validáció
    if not data.firstname or #data.firstname < Config.MinFirstnameLength or #data.firstname > Config.MaxFirstnameLength then
        TriggerClientEvent('sm_char:registrationError', src, 'Érvénytelen keresztnév!')
        return
    end
    
    if not data.lastname or #data.lastname < Config.MinLastnameLength or #data.lastname > Config.MaxLastnameLength then
        TriggerClientEvent('sm_char:registrationError', src, 'Érvénytelen vezetéknév!')
        return
    end
    
    if not data.dateofbirth or not string.match(data.dateofbirth, '%d%d/%d%d/%d%d%d%d') then
        TriggerClientEvent('sm_char:registrationError', src, 'Érvénytelen születési dátum!')
        return
    end
    
    if not data.gender or (data.gender ~= 'm' and data.gender ~= 'f') then
        TriggerClientEvent('sm_char:registrationError', src, 'Érvénytelen nem!')
        return
    end
    
    if not data.height or data.height < Config.MinHeight or data.height > Config.MaxHeight then
        TriggerClientEvent('sm_char:registrationError', src, 'Érvénytelen magasság!')
        return
    end
    
    -- Kor ellenőrzés
    local dobParts = {}
    for part in string.gmatch(data.dateofbirth, '[^/]+') do
        table.insert(dobParts, tonumber(part))
    end
    
    local currentYear = tonumber(os.date('%Y'))
    local age = currentYear - dobParts[3]
    
    if age < Config.MinAge or age > Config.MaxAge then
        TriggerClientEvent('sm_char:registrationError', src, 'Érvénytelen életkor! (' .. Config.MinAge .. '-' .. Config.MaxAge .. ' között)')
        return
    end
    
    -- Triggereljük az sm_core-nak hogy mentse el az adatokat
    TriggerEvent('sm_core:setCharacterData', src, data)
    
    print('^2[SM_CHAR]^7 Karakter regisztrálva: ' .. data.firstname .. ' ' .. data.lastname)
    
    -- Sikeres regisztráció
    TriggerClientEvent('sm_char:registrationSuccess', src)
end)