addEventListener('turbo:click', (e) => {
    console.log(e.detail.url);

    history.pushState({}, null, e.detail.url);
})