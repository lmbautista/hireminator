import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea"]

  connect() {
    console.log("TextareaAutogrow controller connected")
    this.element.style.height = "auto"
    this.element.style.height = this.element.scrollHeight + "px"
  }

  resize() {
    console.log("Resize called")
    this.element.style.height = "auto"
    this.element.style.height = this.element.scrollHeight + "px"
  }

  onInput(event) {
    console.log("Input event")
    this.resize()
  }

  onKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.form.requestSubmit()
    }
  }
}