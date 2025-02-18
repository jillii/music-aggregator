const handleSliderNav = () => {
    const navs = document.getElementsByClassName('slider-nav')

    Array.from(navs).forEach(nav => {
        const prev = nav.querySelector('#slider-prev')
        const next = nav.querySelector('#slider-next')
        const slider = nav.nextElementSibling

        prev.addEventListener("click", (e) => {
            e.preventDefault()
            scrollHorizontally(slider, -400)
        })
        next.addEventListener("click", (e) => {
            e.preventDefault()
            scrollHorizontally(slider, 400)
        })
    })
    function scrollHorizontally(element, scrollAmount) {
        element.scrollLeft += scrollAmount;
    }
}
addEventListener('turbo:frame-load', handleSliderNav)
addEventListener('turbo:load', handleSliderNav)
