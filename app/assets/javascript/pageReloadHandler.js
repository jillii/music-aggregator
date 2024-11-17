addEventListener('turbo:click', (e) => {
    history.pushState({}, null, e.detail.url);
})

addEventListener('turbo:submit-end', (e) => {
    history.pushState({}, null, e.detail.fetchResponse.response.url);
})