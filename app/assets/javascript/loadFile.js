var loadFile = function(event) {
    // get size in megabytes
    const size = event.srcElement.files[0].size / 1048576
    const errorMsg = document.getElementById("image-error")
    const output = document.getElementById('output')
    if (size > 1) {
      errorMsg.innerHTML = "Sorry, that image is too big."
      event.target.value = ""
      output.src = ""
    } else {
      errorMsg.innerHTML = ""
      const reader = new FileReader()
      reader.onload = function() {
        output.src = reader.result
      }
      reader.readAsDataURL(event.target.files[0])
    }
}