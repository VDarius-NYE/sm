Config = {}

-- Karakter létrehozás helyszín (Fort Zancudo)
Config.CreationCoords = vector4(-1036.58, -2731.56, 20.17, 240.0)

-- Kamera beállítások
Config.CamCoords = vector3(-1034.5, -2730.0, 21.5)
Config.CamRotation = vector3(0.0, 0.0, 60.0)
Config.CamFov = 50.0

-- Férfi alapértelmezett skin
Config.DefaultMaleSkin = {
    -- Szülők
    mom = 21,
    dad = 0,
    face_md_weight = 0.5,
    skin_md_weight = 0.5,
    
    -- Arc jellemzők
    nose_width = 0.0,
    nose_peak_height = 0.0,
    nose_peak_length = 0.0,
    nose_bone_height = 0.0,
    nose_peak_lowering = 0.0,
    nose_bone_twist = 0.0,
    eyebrow_height = 0.0,
    eyebrow_forward = 0.0,
    cheeks_bone_high = 0.0,
    cheeks_bone_width = 0.0,
    cheeks_width = 0.0,
    eyes_opening = 0.0,
    lips_thickness = 0.0,
    jaw_bone_width = 0.0,
    jaw_bone_back_length = 0.0,
    chimp_bone_lowering = 0.0,
    chimp_bone_length = 0.0,
    chimp_bone_width = 0.0,
    chimp_hole = 0.0,
    neck_thickness = 0.0,
    
    -- Megjelenés
    face_texture = 0,
    skin_texture = 0,
    complexion = -1,
    sun_damage = -1,
    freckles = -1,
    aging = -1,
    blemishes = -1,
    
    -- Haj
    hair = 0,
    hair_color = 0,
    hair_highlight = 0,
    
    -- Arcszőrzet
    beard = -1,
    beard_color = 0,
    eyebrow = 0,
    eyebrow_color = 0,
    
    -- Smink (férfiaknak általában üres)
    lipstick = -1,
    lipstick_color = 0,
    blush = -1,
    blush_color = 0,
    makeup = -1,
    
    -- Szemek
    eye_color = 0,
    
    -- Tetoválások (később)
    torso = {},
    head = {},
    left_arm = {},
    right_arm = {},
    left_leg = {},
    right_leg = {}
}

-- Női alapértelmezett skin
Config.DefaultFemaleSkin = {
    mom = 21,
    dad = 0,
    face_md_weight = 0.5,
    skin_md_weight = 0.5,
    
    nose_width = 0.0,
    nose_peak_height = 0.0,
    nose_peak_length = 0.0,
    nose_bone_height = 0.0,
    nose_peak_lowering = 0.0,
    nose_bone_twist = 0.0,
    eyebrow_height = 0.0,
    eyebrow_forward = 0.0,
    cheeks_bone_high = 0.0,
    cheeks_bone_width = 0.0,
    cheeks_width = 0.0,
    eyes_opening = 0.0,
    lips_thickness = 0.0,
    jaw_bone_width = 0.0,
    jaw_bone_back_length = 0.0,
    chimp_bone_lowering = 0.0,
    chimp_bone_length = 0.0,
    chimp_bone_width = 0.0,
    chimp_hole = 0.0,
    neck_thickness = 0.0,
    
    face_texture = 0,
    skin_texture = 0,
    complexion = -1,
    sun_damage = -1,
    freckles = -1,
    aging = -1,
    blemishes = -1,
    
    hair = 0,
    hair_color = 0,
    hair_highlight = 0,
    
    beard = -1,
    beard_color = 0,
    eyebrow = 0,
    eyebrow_color = 0,
    
    lipstick = -1,
    lipstick_color = 0,
    blush = -1,
    blush_color = 0,
    makeup = -1,
    
    eye_color = 0,
    
    torso = {},
    head = {},
    left_arm = {},
    right_arm = {},
    left_leg = {},
    right_leg = {}
}

-- Ruházat alapértelmezett (férfi - katonai)
Config.DefaultMaleClothing = {
    tshirt = {drawable = 15, texture = 0},
    torso = {drawable = 287, texture = 0},  -- Katonai zubbony
    decals = {drawable = 0, texture = 0},
    arms = {drawable = 0, texture = 0},
    pants = {drawable = 86, texture = 0},   -- Katonai nadrág
    shoes = {drawable = 24, texture = 0},   -- Katonai csizma
    chain = {drawable = 0, texture = 0},
    bodyarmor = {drawable = 0, texture = 0},
    bag = {drawable = 0, texture = 0},
    hat = {drawable = -1, texture = 0},
    glasses = {drawable = -1, texture = 0},
    ear = {drawable = -1, texture = 0},
    watch = {drawable = -1, texture = 0},
    bracelet = {drawable = -1, texture = 0}
}

-- Ruházat alapértelmezett (női - katonai)
Config.DefaultFemaleClothing = {
    tshirt = {drawable = 14, texture = 0},
    torso = {drawable = 325, texture = 0},
    decals = {drawable = 0, texture = 0},
    arms = {drawable = 14, texture = 0},
    pants = {drawable = 93, texture = 0},
    shoes = {drawable = 24, texture = 0},
    chain = {drawable = 0, texture = 0},
    bodyarmor = {drawable = 0, texture = 0},
    bag = {drawable = 0, texture = 0},
    hat = {drawable = -1, texture = 0},
    glasses = {drawable = -1, texture = 0},
    ear = {drawable = -1, texture = 0},
    watch = {drawable = -1, texture = 0},
    bracelet = {drawable = -1, texture = 0}
}