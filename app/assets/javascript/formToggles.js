const openForm = (e) => {
    const btn = e.target
    const form = document.querySelectorAll('[data-toggle-form="' + btn.dataset.toggle + '"]')
    const orig = document.querySelectorAll('[data-toggle-original="' + btn.dataset.toggle + '"]')

    form.forEach(item => item.classList.toggle("hidden"))
    orig.forEach(item => item.classList.toggle("hidden"))
    if (!btn.classList.contains('no-hide')) {
        btn.classList.add('hidden')
    }
}

addEventListener('turbo:frame-load', () => {
    document.querySelectorAll(".form-toggle").forEach(toggle => {
        toggle.addEventListener("click", openForm)
    })
})
addEventListener('turbo:load', () => {
    document.querySelectorAll(".form-toggle").forEach(toggle => {
        toggle.addEventListener("click", openForm)
    })
})

const closeForm = (e) => {
    const form = e.target.parentElement
    const btn = document.querySelectorAll('[data-toggle="' + form.dataset.toggleForm + '"]')
    const orig = document.querySelectorAll('[data-toggle-original="' + form.dataset.toggleForm + '"]')

    form.classList.add("hidden")
    btn.forEach(item => item.classList.remove("hidden"))
    orig.forEach(item => item.classList.remove("hidden"))
}



addEventListener('turbo:frame-load', () => {
    document.querySelectorAll("button[type='reset']").forEach(btn => {
        btn.addEventListener("click", closeForm)
    })
})
addEventListener('turbo:load', () => {
    document.querySelectorAll("button[type='reset']").forEach(btn => {
        btn.addEventListener("click", closeForm)
    })
})
