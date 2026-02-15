window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'show') {
        const loadingDiv = document.getElementById('loading');
        const messageText = document.getElementById('loading-message');
        
        if (data.text) {
            messageText.textContent = data.text;
        }
        
        loadingDiv.classList.remove('hidden');
    } else if (data.action === 'hide') {
        const loadingDiv = document.getElementById('loading');
        loadingDiv.classList.add('hidden');
    }
});