let currentSkin = {};
let currentClothes = {};
let currentGender = 'm';

// Tab váltás
document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        // Tab gombok
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        
        // Tab tartalmak
        document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
        const tabId = this.getAttribute('data-tab') + '-tab';
        document.getElementById(tabId).classList.add('active');
    });
});

// Range sliderek kezelése (Skin)
const skinInputs = [
    'mom', 'dad', 'face_md_weight', 'skin_md_weight',
    'nose_width', 'nose_peak_height', 'nose_peak_length', 'nose_bone_height',
    'nose_peak_lowering', 'nose_bone_twist', 'eyebrow_height', 'eyebrow_forward',
    'cheeks_bone_high', 'cheeks_bone_width', 'cheeks_width', 'eyes_opening',
    'lips_thickness', 'jaw_bone_width', 'jaw_bone_back_length',
    'chimp_bone_lowering', 'chimp_bone_length', 'chimp_bone_width', 'chimp_hole',
    'neck_thickness', 'hair', 'hair_color', 'hair_highlight', 'eyebrow',
    'eyebrow_color', 'beard', 'beard_color', 'eye_color', 'aging',
    'complexion', 'sun_damage', 'freckles', 'blemishes',
    'lipstick', 'lipstick_color', 'blush', 'blush_color', 'makeup'
];

skinInputs.forEach(inputId => {
    const rangeInput = document.getElementById(inputId);
    const numberInput = document.getElementById(inputId + '-input');
    const currentSpan = document.getElementById(inputId + '-current');
    
    if (!rangeInput) return;
    
    // Range slider változás
    rangeInput.addEventListener('input', function() {
        const value = parseFloat(this.value);
        
        // Frissítsd a number inputot és a span-t
        if (numberInput) numberInput.value = value;
        if (currentSpan) currentSpan.textContent = value;
        
        currentSkin[inputId] = value;
        updateSkin();
    });
    
    // Number input változás
    if (numberInput) {
        numberInput.addEventListener('input', function() {
            let value = parseFloat(this.value);
            const min = parseFloat(this.min);
            const max = parseFloat(this.max);
            
            // Validálás
            if (isNaN(value)) value = min;
            if (value < min) value = min;
            if (value > max) value = max;
            
            // Frissítsd a range slidert és a span-t
            rangeInput.value = value;
            if (currentSpan) currentSpan.textContent = value;
            this.value = value;
            
            currentSkin[inputId] = value;
            updateSkin();
        });
    }
});

// Range sliderek kezelése (Ruházat)
const clothingInputs = [
    'torso', 'torso_texture', 
    'pants', 'pants_texture', 
    'shoes', 'shoes_texture', 
    'bag', 'bag_texture',
    'chain', 'chain_texture',
    'hat', 'hat_texture', 
    'glasses', 'glasses_texture',
    'watch', 'watch_texture',
    'bracelet', 'bracelet_texture'
];

clothingInputs.forEach(inputId => {
    const rangeInput = document.getElementById(inputId);
    const numberInput = document.getElementById(inputId + '-input');
    const currentSpan = document.getElementById(inputId + '-current');
    
    if (!rangeInput) return;
    
    // Range slider változás
    rangeInput.addEventListener('input', function() {
        const value = parseInt(this.value);
        
        // Frissítsd a number inputot és a span-t
        if (numberInput) numberInput.value = value;
        if (currentSpan) currentSpan.textContent = value;
        
        updateClothing(inputId, value);
    });
    
    // Number input változás
    if (numberInput) {
        numberInput.addEventListener('input', function() {
            let value = parseInt(this.value);
            const min = parseInt(this.min);
            const max = parseInt(this.max);
            
            // Validálás
            if (isNaN(value)) value = min;
            if (value < min) value = min;
            if (value > max) value = max;
            
            // Frissítsd a range slidert és a span-t
            rangeInput.value = value;
            if (currentSpan) currentSpan.textContent = value;
            this.value = value;
            
            updateClothing(inputId, value);
        });
    }
});

function updateSkin() {
    fetch(`https://${GetParentResourceName()}/updateSkin`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            skin: currentSkin
        })
    });
}

function updateClothing(type, value) {
    // Clothing objektum frissítése
    switch(type) {
        case 'torso':
            if (!currentClothes.torso) currentClothes.torso = { drawable: 0, texture: 0 };
            currentClothes.torso.drawable = value;
            break;
        case 'torso_texture':
            if (!currentClothes.torso) currentClothes.torso = { drawable: 0, texture: 0 };
            currentClothes.torso.texture = value;
            break;
        case 'pants':
            if (!currentClothes.pants) currentClothes.pants = { drawable: 0, texture: 0 };
            currentClothes.pants.drawable = value;
            break;
        case 'pants_texture':
            if (!currentClothes.pants) currentClothes.pants = { drawable: 0, texture: 0 };
            currentClothes.pants.texture = value;
            break;
        case 'shoes':
            if (!currentClothes.shoes) currentClothes.shoes = { drawable: 0, texture: 0 };
            currentClothes.shoes.drawable = value;
            break;
        case 'shoes_texture':
            if (!currentClothes.shoes) currentClothes.shoes = { drawable: 0, texture: 0 };
            currentClothes.shoes.texture = value;
            break;
        case 'bag':
            if (!currentClothes.bag) currentClothes.bag = { drawable: 0, texture: 0 };
            currentClothes.bag.drawable = value;
            break;
        case 'bag_texture':
            if (!currentClothes.bag) currentClothes.bag = { drawable: 0, texture: 0 };
            currentClothes.bag.texture = value;
            break;
        case 'chain':
            if (!currentClothes.chain) currentClothes.chain = { drawable: 0, texture: 0 };
            currentClothes.chain.drawable = value;
            break;
        case 'chain_texture':
            if (!currentClothes.chain) currentClothes.chain = { drawable: 0, texture: 0 };
            currentClothes.chain.texture = value;
            break;
        case 'hat':
            if (!currentClothes.hat) currentClothes.hat = { drawable: -1, texture: 0 };
            currentClothes.hat.drawable = value;
            break;
        case 'hat_texture':
            if (!currentClothes.hat) currentClothes.hat = { drawable: -1, texture: 0 };
            currentClothes.hat.texture = value;
            break;
        case 'glasses':
            if (!currentClothes.glasses) currentClothes.glasses = { drawable: -1, texture: 0 };
            currentClothes.glasses.drawable = value;
            break;
        case 'glasses_texture':
            if (!currentClothes.glasses) currentClothes.glasses = { drawable: -1, texture: 0 };
            currentClothes.glasses.texture = value;
            break;
        case 'watch':
            if (!currentClothes.watch) currentClothes.watch = { drawable: -1, texture: 0 };
            currentClothes.watch.drawable = value;
            break;
        case 'watch_texture':
            if (!currentClothes.watch) currentClothes.watch = { drawable: -1, texture: 0 };
            currentClothes.watch.texture = value;
            break;
        case 'bracelet':
            if (!currentClothes.bracelet) currentClothes.bracelet = { drawable: -1, texture: 0 };
            currentClothes.bracelet.drawable = value;
            break;
        case 'bracelet_texture':
            if (!currentClothes.bracelet) currentClothes.bracelet = { drawable: -1, texture: 0 };
            currentClothes.bracelet.texture = value;
            break;
    }
    
    fetch(`https://${GetParentResourceName()}/updateClothing`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            clothes: currentClothes
        })
    });
}

// Mentés gomb
document.getElementById('save-btn').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/saveCharacter`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            skin: currentSkin,
            clothes: currentClothes
        })
    });
});

// NUI üzenetek kezelése
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'openCreator') {
        currentGender = data.gender;
        currentSkin = data.skin;
        currentClothes = data.clothes;
        
        // Sliderek értékeinek beállítása
        loadSkinValues(data.skin);
        loadClothingValues(data.clothes);
        
        document.getElementById('creator').classList.remove('hidden');
    } else if (data.action === 'closeCreator') {
        document.getElementById('creator').classList.add('hidden');
    }
});

function loadSkinValues(skin) {
    for (const [key, value] of Object.entries(skin)) {
        const rangeInput = document.getElementById(key);
        const numberInput = document.getElementById(key + '-input');
        const currentSpan = document.getElementById(key + '-current');
        
        if (rangeInput) rangeInput.value = value;
        if (numberInput) numberInput.value = value;
        if (currentSpan) currentSpan.textContent = value;
    }
}

function loadClothingValues(clothes) {
    const clothingMap = {
        'torso': clothes.torso,
        'pants': clothes.pants,
        'shoes': clothes.shoes,
        'bag': clothes.bag,
        'chain': clothes.chain,
        'hat': clothes.hat,
        'glasses': clothes.glasses,
        'watch': clothes.watch,
        'bracelet': clothes.bracelet
    };
    
    for (const [key, value] of Object.entries(clothingMap)) {
        if (value) {
            // Drawable
            const drawableRange = document.getElementById(key);
            const drawableNumber = document.getElementById(key + '-input');
            const drawableCurrent = document.getElementById(key + '-current');
            
            if (drawableRange) drawableRange.value = value.drawable;
            if (drawableNumber) drawableNumber.value = value.drawable;
            if (drawableCurrent) drawableCurrent.textContent = value.drawable;
            
            // Texture
            const textureRange = document.getElementById(key + '_texture');
            const textureNumber = document.getElementById(key + '_texture-input');
            const textureCurrent = document.getElementById(key + '_texture-current');
            
            if (textureRange) textureRange.value = value.texture;
            if (textureNumber) textureNumber.value = value.texture;
            if (textureCurrent) textureCurrent.textContent = value.texture;
        }
    }
}

// A és D billentyűk kezelése karakter forgatáshoz
document.addEventListener('keydown', function(event) {
    if (event.key === 'a' || event.key === 'A') {
        fetch(`https://${GetParentResourceName()}/rotatePed`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                rotation: -20
            })
        });
    } else if (event.key === 'd' || event.key === 'D') {
        fetch(`https://${GetParentResourceName()}/rotatePed`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                rotation: 20
            })
        });
    }
});