const textareaDelineate = () => {
    document.querySelectorAll('textarea.tags').forEach(textarea => {
        const tagList = textarea.parentElement
        const collector = tagList.nextElementSibling
        const form = textarea.closest('form')
        textarea.addEventListener('keypress', (event) => {
            if (window.event.keyCode === 13) { // check if key is enter
                const input = stripHtml(event.target.value)
                if (input !== '' && input !== ' ') {
                    let pill = document.createElement('span')
                    pill.className = "tag-pill"
                    pill.textContent = input.trim()
                    pill.addEventListener("click", function() {this.remove()})
                    textarea.before(pill)
                    event.target.value = "" // reset textarea
                }
            }
        })
        // collect tags in hidden field upon form submit
        form.addEventListener('submit', (e) => {
            let tags = ""
            Array.from(tagList.children).forEach(el => {console.log(el.tagName); if (el.tagName !== 'TEXTAREA') {tags += `${el.innerHTML},`}})
            collector.value = tags
        })
    })
}

document

addEventListener('turbo:frame-load', textareaDelineate)
addEventListener('turbo:load', textareaDelineate)

function stripHtml(html) {
    var tmp = document.createElement("DIV");
    tmp.innerHTML = html;
    return tmp.textContent || tmp.innerText;
}