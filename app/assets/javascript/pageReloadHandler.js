addEventListener('turbo:click', (e) => {
    history.pushState({}, null, e.detail.url);
})

addEventListener('turbo:submit-end', (e) => {
    history.pushState({}, null, e.detail.fetchResponse.response.url);
})

// Reload page if user clicks browser back button
addEventListener("popstate", (event) => {
    Turbo.visit(window.location.href, { action: "replace" });
});