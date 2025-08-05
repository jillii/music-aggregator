addEventListener('turbo:click', (e) => {
    history.pushState({}, null, e.detail.url);
})

addEventListener('turbo:submit-end', (e) => {
    const url = e.detail.fetchResponse.response.url
    if (!url.includes('/tracklists/')) {
        console.log("this happenend")
        history.pushState({}, null, url);
    }
})

// Reload page if user clicks browser back button
addEventListener("popstate", (event) => {
    Turbo.visit(window.location.href, { action: "replace" });
});