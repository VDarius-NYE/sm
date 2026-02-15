let selectedGender = 'm';

// Gender button kezelés
document.querySelectorAll('.gender-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.gender-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        selectedGender = this.getAttribute('data-gender');
    });
});

// Dátum formázás
document.getElementById('dateofbirth').addEventListener('input', function(e) {
    let value = e.target.value.replace(/\D/g, '');
    
    if (value.length >= 2) {
        value = value.substring(0, 2) + '/' + value.substring(2);
    }
    if (value.length >= 5) {
        value = value.substring(0, 5) + '/' + value.substring(5, 9);
    }
    
    e.target.value = value;
});

// Submit button
document.getElementById('submit-btn').addEventListener('click', function() {
    const firstname = document.getElementById('firstname').value.trim();
    const lastname = document.getElementById('lastname').value.trim();
    const dateofbirth = document.getElementById('dateofbirth').value.trim();
    const height = parseInt(document.getElementById('height').value);

    // Validáció
    if (!firstname || firstname.length < 2) {
        showError('Add meg a keresztneved! (min. 2 karakter)');
        return;
    }

    if (!lastname || lastname.length < 2) {
        showError('Add meg a vezetékneved! (min. 2 karakter)');
        return;
    }

    if (!dateofbirth || !dateofbirth.match(/\d\d\/\d\d\/\d\d\d\d/)) {
        showError('Érvénytelen dátum formátum! (HH/NN/ÉÉÉÉ)');
        return;
    }

    if (!height || height < 140 || height > 220) {
        showError('Érvénytelen magasság! (140-220 cm között)');
        return;
    }

    // Adatok küldése
    fetch(`https://${GetParentResourceName()}/registerCharacter`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            firstname: firstname,
            lastname: lastname,
            dateofbirth: dateofbirth,
            gender: selectedGender,
            height: height
        })
    });
});

// Hibaüzenet megjelenítés
function showError(message) {
    const errorDiv = document.getElementById('error-message');
    errorDiv.textContent = message;
    errorDiv.classList.remove('hidden');
    
    setTimeout(() => {
        errorDiv.classList.add('hidden');
    }, 5000);
}

// NUI üzenetek kezelése
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'openRegistration') {
        document.getElementById('registration').classList.remove('hidden');
    } else if (data.action === 'closeRegistration') {
        document.getElementById('registration').classList.add('hidden');
    } else if (data.action === 'showError') {
        showError(data.message);
    }
});