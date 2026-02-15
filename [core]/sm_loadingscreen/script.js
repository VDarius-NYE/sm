let count = 0;
let thisCount = 0;
let hasShutdown = false;

const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;
    },

    initFunctionInvoking(data) {
        // Tartsd a loading screent
    },

    startDataFileEntries(data) {
        count = data.count;
    },

    performMapLoadFunction(data) {
        thisCount++;
        // NE zárjuk be automatikusan!
    },
    
    // ÚJ - Script mondja meg mikor tűnjön el
    shutdownLoadingScreen() {
        if (!hasShutdown) {
            hasShutdown = true;
            // FiveM API - engedjük el a loading screent
            if (window.invokeNative) {
                window.invokeNative('0xD80958FC74E988A6'); // SHUTDOWN_LOADING_SCREEN
            }
        }
    }
};

window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'show') {
        const loadingDiv = document.getElementById('loading');
        const messageText = document.getElementById('loading-message');
        
        if (data.text) {
            messageText.textContent = data.text;
        }
        
        loadingDiv.classList.remove('hidden');
        console.log('Loading screen megjelenítve:', data.text);
    } else if (data.action === 'hide') {
        const loadingDiv = document.getElementById('loading');
        loadingDiv.classList.add('hidden');
        console.log('Loading screen elrejtve');
    }
});

// Jelezzük a Lua-nak hogy az NUI kész
window.addEventListener('load', function() {
    console.log('NUI betöltve, jelzés küldése...');
    
    // Küldjünk egy üzenetet hogy készen vagyunk
    fetch(`https://${GetParentResourceName()}/nuiReady`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).catch(() => {
        // Ha nincs még NUI context, próbáld újra
        setTimeout(() => {
            fetch(`https://${GetParentResourceName()}/nuiReady`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            }).catch(() => {});
        }, 500);
    });
});