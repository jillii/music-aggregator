const emerge = () => {

    const emergeCards = document.querySelectorAll('.emerge .card')

    emergeCards.forEach(card => {
        // Create observer
        const observer = new IntersectionObserver((entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) {
                    card.classList.add('visible')
                } else {
                    card.classList.remove('visible')
                }
            });
        });

        const options = {
            threshold: 1,
        };
        
        // Start observing element
        observer.observe(card, options);
    })
}

addEventListener('turbo:frame-load', emerge)
addEventListener('turbo:load', emerge)