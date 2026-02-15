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
    const input = document.getElementById(inputId);
    if (!input) return;
    
    const valueSpan = document.getElementById(inputId + '-value');
    
    input.addEventListener('input', function() {
        const value = parseFloat(this.value);
        if (valueSpan) valueSpan.textContent = value;
        
        currentSkin[inputId] = value;
        updateSkin();
    });
});

// Range sliderek kezelése (Ruházat)
const clothingInputs = ['torso', 'pants', 'shoes', 'hat', 'glasses'];

clothingInputs.forEach(inputId => {
    const input = document.getElementById(inputId);
    if (!input) return;
    
    const valueSpan = document.getElementById(inputId + '-value');
    
    input.addEventListener('input', function() {
        const value = parseInt(this.value);
        if (valueSpan) valueSpan.textContent = value;
        
        updateClothing(inputId, value);
    });
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
            currentClothes.torso = { drawable: value, texture: 0 };
            break;
        case 'pants':
            currentClothes.pants = { drawable: value, texture: 0 };
            break;
        case 'shoes':
            currentClothes.shoes = { drawable: value, texture: 0 };
            break;
        case 'hat':
            currentClothes.hat = { drawable: value, texture: 0 };
            break;
        case 'glasses':
            currentClothes.glasses = { drawable: value, texture: 0 };
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

// Forgatás gombok
document.getElementById('rotate-left').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/rotatePed`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            rotation: -20
        })
    });
});

document.getElementById('rotate-right').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/rotatePed`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            rotation: 20
        })
    });
});

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
        const input = document.getElementById(key);
        const valueSpan = document.getElementById(key + '-value');
        
        if (input) {
            input.value = value;
            if (valueSpan) valueSpan.textContent = value;
        }
    }
}

function loadClothingValues(clothes) {
    if (clothes.torso) {
        const torsoInput = document.getElementById('torso');
        const torsoValue = document.getElementById('torso-value');
        if (torsoInput) torsoInput.value = clothes.torso.drawable;
        if (torsoValue) torsoValue.textContent = clothes.torso.drawable;
    }
    
    if (clothes.pants) {
        const pantsInput = document.getElementById('pants');
        const pantsValue = document.getElementById('pants-value');
        if (pantsInput) pantsInput.value = clothes.pants.drawable;
        if (pantsValue) pantsValue.textContent = clothes.pants.drawable;
    }
    
    if (clothes.shoes) {
        const shoesInput = document.getElementById('shoes');
        const shoesValue = document.getElementById('shoes-value');
        if (shoesInput) shoesInput.value = clothes.shoes.drawable;
        if (shoesValue) shoesValue.textContent = clothes.shoes.drawable;
    }
    
    if (clothes.hat) {
        const hatInput = document.getElementById('hat');
        const hatValue = document.getElementById('hat-value');
        if (hatInput) hatInput.value = clothes.hat.drawable;
        if (hatValue) hatValue.textContent = clothes.hat.drawable;
    }
    
    if (clothes.glasses) {
        const glassesInput = document.getElementById('glasses');
        const glassesValue = document.getElementById('glasses-value');
        if (glassesInput) glassesInput.value = clothes.glasses.drawable;
        if (glassesValue) glassesValue.textContent = clothes.glasses.drawable;
    }
}

// ESC billentyű kezelés
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeCreator`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }
});