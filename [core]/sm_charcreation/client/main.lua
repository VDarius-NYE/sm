local isCreatingCharacter = false
local cam = nil

-- Karakter létrehozás megnyitása
RegisterNetEvent('sm_charcreation:open', function()
    print('^2[SM_CHARCREATION]^7 sm_charcreation:open event fogadva')
    
    if isCreatingCharacter then 
        print('^3[SM_CHARCREATION]^7 Már fut a karakterkészítő')
        return 
    end
    
    -- Ellenőrizd hogy az SM és PlayerData létezik
    if not SM then
        print('^1[SM_CHARCREATION ERROR]^7 SM nem létezik!')
        return
    end
    
    if not SM.PlayerData then
        print('^1[SM_CHARCREATION ERROR]^7 SM.PlayerData nem létezik!')
        return
    end
    
    print('^2[SM_CHARCREATION]^7 OpenCharacterCreation meghívása...')
    OpenCharacterCreation()
end)

function OpenCharacterCreation()
    isCreatingCharacter = true
    
    print('^2[SM_CHARCREATION]^7 Karakterkészítő megnyitása folyamatban...')
    
    DoScreenFadeOut(500)
    Wait(500)
    
    local ped = PlayerPedId()
    
    -- KARAKTERKÉSZÍTŐ POZÍCIÓ - Fort Zancudo bejárat (FÖLDÖN!)
    local creationCoords = vector4(-1036.58, -2731.56, 20.17, 240.0)
    
    -- Teleportálás a FÖLDRE
    SetEntityCoords(ped, creationCoords.x, creationCoords.y, creationCoords.z, false, false, false, false)
    SetEntityHeading(ped, creationCoords.w)
    
    print('^3[SM_CHARCREATION]^7 Karakter teleportálva földre: ' .. creationCoords.x .. ', ' .. creationCoords.y .. ', ' .. creationCoords.z)
    
    -- Alap skin alkalmazása a nem alapján
    local gender = SM.PlayerData.gender or 'm'
    print('^3[SM_CHARCREATION DEBUG]^7 Gender: ' .. gender)
    
    local model = gender == 'm' and 'mp_m_freemode_01' or 'mp_f_freemode_01'
    
    print('^3[SM_CHARCREATION]^7 Model betöltése: ' .. model)
    
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(0)
    end
    
    print('^3[SM_CHARCREATION]^7 Model betöltve, alkalmazás...')
    
    SetPlayerModel(PlayerId(), GetHashKey(model))
    SetPedDefaultComponentVariation(PlayerPedId())
    
    ped = PlayerPedId() -- Frissítsd a ped változót az új model után
    
    print('^3[SM_CHARCREATION]^7 Model alkalmazva')
    
    -- Most már láthatóvá teheted
    SetEntityVisible(ped, true, 0)
    FreezeEntityPosition(ped, true)
    SetEntityCollision(ped, true, true)
    
    -- Alapértelmezett skin alkalmazása
    local defaultSkin = gender == 'm' and Config.DefaultMaleSkin or Config.DefaultFemaleSkin
    ApplySkin(defaultSkin)
    
    print('^3[SM_CHARCREATION]^7 Skin alkalmazva')
    
    -- Alapértelmezett ruházat
    local defaultClothes = gender == 'm' and Config.DefaultMaleClothing or Config.DefaultFemaleClothing
    ApplyClothing(defaultClothes)
    
    print('^3[SM_CHARCREATION]^7 Ruházat alkalmazva')
    
    -- Kamera beállítás - a karakter körül
    local coords = GetEntityCoords(ped)
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    
    -- Kamera beállítása a karakter elé és kissé feljebb
    local camCoords = vector3(coords.x + 1.5, coords.y + 1.5, coords.z + 0.5)
    SetCamCoord(cam, camCoords.x, camCoords.y, camCoords.z)
    PointCamAtEntity(cam, ped, 0.0, 0.0, 0.5, true)
    SetCamFov(cam, 50.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    
    print('^3[SM_CHARCREATION]^7 Kamera beállítva')
    
    DoScreenFadeIn(500)
    
    -- UI megnyitás
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openCreator',
        gender = gender,
        skin = defaultSkin,
        clothes = defaultClothes
    })
    
    print('^2[SM_CHARCREATION]^7 UI megnyitva!')
end

function CloseCharacterCreation()
    isCreatingCharacter = false
    
    -- UI bezárás
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeCreator'
    })
    
    -- Kamera törlés
    if cam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
    
    print('^2[SM_CHARCREATION]^7 Karakterkészítő bezárva, spawn triggerelése...')
    
    -- Spawn a loading screen-el
    TriggerEvent('sm_loaded:spawnAfterCreation')
end

-- Skin alkalmazása
function ApplySkin(skin)
    local ped = PlayerPedId()
    
    -- Szülők
    SetPedHeadBlendData(ped, skin.mom, skin.dad, 0, skin.mom, skin.dad, 0, skin.face_md_weight, skin.skin_md_weight, 0.0, false)
    
    -- Arc jellemzők
    SetPedFaceFeature(ped, 0, skin.nose_width)
    SetPedFaceFeature(ped, 1, skin.nose_peak_height)
    SetPedFaceFeature(ped, 2, skin.nose_peak_length)
    SetPedFaceFeature(ped, 3, skin.nose_bone_height)
    SetPedFaceFeature(ped, 4, skin.nose_peak_lowering)
    SetPedFaceFeature(ped, 5, skin.nose_bone_twist)
    SetPedFaceFeature(ped, 6, skin.eyebrow_height)
    SetPedFaceFeature(ped, 7, skin.eyebrow_forward)
    SetPedFaceFeature(ped, 8, skin.cheeks_bone_high)
    SetPedFaceFeature(ped, 9, skin.cheeks_bone_width)
    SetPedFaceFeature(ped, 10, skin.cheeks_width)
    SetPedFaceFeature(ped, 11, skin.eyes_opening)
    SetPedFaceFeature(ped, 12, skin.lips_thickness)
    SetPedFaceFeature(ped, 13, skin.jaw_bone_width)
    SetPedFaceFeature(ped, 14, skin.jaw_bone_back_length)
    SetPedFaceFeature(ped, 15, skin.chimp_bone_lowering)
    SetPedFaceFeature(ped, 16, skin.chimp_bone_length)
    SetPedFaceFeature(ped, 17, skin.chimp_bone_width)
    SetPedFaceFeature(ped, 18, skin.chimp_hole)
    SetPedFaceFeature(ped, 19, skin.neck_thickness)
    
    -- Megjelenés overlays
    if skin.blemishes and skin.blemishes > -1 then SetPedHeadOverlay(ped, 0, skin.blemishes, 1.0) end
    if skin.beard and skin.beard > -1 then SetPedHeadOverlay(ped, 1, skin.beard, 1.0) end
    if skin.eyebrow and skin.eyebrow > -1 then SetPedHeadOverlay(ped, 2, skin.eyebrow, 1.0) end
    if skin.aging and skin.aging > -1 then SetPedHeadOverlay(ped, 3, skin.aging, 1.0) end
    if skin.makeup and skin.makeup > -1 then SetPedHeadOverlay(ped, 4, skin.makeup, 1.0) end
    if skin.blush and skin.blush > -1 then SetPedHeadOverlay(ped, 5, skin.blush, 1.0) end
    if skin.complexion and skin.complexion > -1 then SetPedHeadOverlay(ped, 6, skin.complexion, 1.0) end
    if skin.sun_damage and skin.sun_damage > -1 then SetPedHeadOverlay(ped, 7, skin.sun_damage, 1.0) end
    if skin.lipstick and skin.lipstick > -1 then SetPedHeadOverlay(ped, 8, skin.lipstick, 1.0) end
    if skin.freckles and skin.freckles > -1 then SetPedHeadOverlay(ped, 9, skin.freckles, 1.0) end
    
    -- Overlay színek
    if skin.beard_color then SetPedHeadOverlayColor(ped, 1, 1, skin.beard_color, skin.beard_color) end
    if skin.eyebrow_color then SetPedHeadOverlayColor(ped, 2, 1, skin.eyebrow_color, skin.eyebrow_color) end
    if skin.blush_color then SetPedHeadOverlayColor(ped, 5, 2, skin.blush_color, skin.blush_color) end
    if skin.lipstick_color then SetPedHeadOverlayColor(ped, 8, 2, skin.lipstick_color, skin.lipstick_color) end
    
    -- Haj
    if skin.hair then SetPedComponentVariation(ped, 2, skin.hair, 0, 0) end
    if skin.hair_color and skin.hair_highlight then SetPedHairColor(ped, skin.hair_color, skin.hair_highlight) end
    
    -- Szem szín
    if skin.eye_color then SetPedEyeColor(ped, skin.eye_color) end
end

-- Ruházat alkalmazása
function ApplyClothing(clothes)
    local ped = PlayerPedId()
    
    if clothes.tshirt then SetPedComponentVariation(ped, 8, clothes.tshirt.drawable, clothes.tshirt.texture, 0) end
    if clothes.torso then SetPedComponentVariation(ped, 11, clothes.torso.drawable, clothes.torso.texture, 0) end
    if clothes.decals then SetPedComponentVariation(ped, 10, clothes.decals.drawable, clothes.decals.texture, 0) end
    if clothes.arms then SetPedComponentVariation(ped, 3, clothes.arms.drawable, clothes.arms.texture, 0) end
    if clothes.pants then SetPedComponentVariation(ped, 4, clothes.pants.drawable, clothes.pants.texture, 0) end
    if clothes.shoes then SetPedComponentVariation(ped, 6, clothes.shoes.drawable, clothes.shoes.texture, 0) end
    if clothes.chain then SetPedComponentVariation(ped, 7, clothes.chain.drawable, clothes.chain.texture, 0) end
    if clothes.bodyarmor then SetPedComponentVariation(ped, 9, clothes.bodyarmor.drawable, clothes.bodyarmor.texture, 0) end
    if clothes.bag then SetPedComponentVariation(ped, 5, clothes.bag.drawable, clothes.bag.texture, 0) end
    
    -- Kiegészítők
    if clothes.hat then
        if clothes.hat.drawable == -1 then
            ClearPedProp(ped, 0)
        else
            SetPedPropIndex(ped, 0, clothes.hat.drawable, clothes.hat.texture, true)
        end
    end
    
    if clothes.glasses then
        if clothes.glasses.drawable == -1 then
            ClearPedProp(ped, 1)
        else
            SetPedPropIndex(ped, 1, clothes.glasses.drawable, clothes.glasses.texture, true)
        end
    end
    
    if clothes.ear then
        if clothes.ear.drawable == -1 then
            ClearPedProp(ped, 2)
        else
            SetPedPropIndex(ped, 2, clothes.ear.drawable, clothes.ear.texture, true)
        end
    end
    
    if clothes.watch then
        if clothes.watch.drawable == -1 then
            ClearPedProp(ped, 6)
        else
            SetPedPropIndex(ped, 6, clothes.watch.drawable, clothes.watch.texture, true)
        end
    end
    
    if clothes.bracelet then
        if clothes.bracelet.drawable == -1 then
            ClearPedProp(ped, 7)
        else
            SetPedPropIndex(ped, 7, clothes.bracelet.drawable, clothes.bracelet.texture, true)
        end
    end
end

-- NUI Callbacks
RegisterNUICallback('updateSkin', function(data, cb)
    ApplySkin(data.skin)
    cb('ok')
end)

RegisterNUICallback('updateClothing', function(data, cb)
    ApplyClothing(data.clothes)
    cb('ok')
end)

RegisterNUICallback('rotatePed', function(data, cb)
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    SetEntityHeading(ped, heading + data.rotation)
    cb('ok')
end)

RegisterNUICallback('saveCharacter', function(data, cb)
    print('^2[SM_CHARCREATION]^7 Karakter mentése...')
    -- Skin mentése
    TriggerServerEvent('sm_charcreation:saveSkin', {
        skin = data.skin,
        clothes = data.clothes
    })
    cb('ok')
end)

RegisterNUICallback('closeCreator', function(data, cb)
    CloseCharacterCreation()
    cb('ok')
end)

-- Skin mentve event
RegisterNetEvent('sm_charcreation:skinSaved', function()
    print('^2[SM_CHARCREATION]^7 Skin sikeresen mentve!')
    CloseCharacterCreation()
end)

-- Mentett skin alkalmazása (spawn-nál)
RegisterNetEvent('sm_charcreation:applySkin', function(skin, clothes)
    if not skin then 
        print('^1[SM_CHARCREATION ERROR]^7 Nincs skin adat!')
        return 
    end
    
    print('^2[SM_CHARCREATION]^7 Mentett skin alkalmazása spawn-nál...')
    
    Wait(500) -- Várj hogy a model betöltődjön
    
    ApplySkin(skin)
    
    if clothes then
        ApplyClothing(clothes)
    end
    
    print('^2[SM_CHARCREATION]^7 Skin sikeresen alkalmazva!')
end)