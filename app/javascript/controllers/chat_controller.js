import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "input", "form"]

  connect() {
    this.scrollToBottom()
  }

  submit(event) {
    event.preventDefault()
    const form = this.formTarget
    const input = this.inputTarget
    const message = input.value.trim()

    if (message) {
      this.addMessage(message, "user")
      input.value = ""
      this.scrollToBottom()

      // Simular respuesta del asistente (esto se reemplazará con la llamada real a la API)
      setTimeout(() => {
        this.addMessage("Gracias por tu mensaje. Estoy procesando tu solicitud...", "assistant")
        this.scrollToBottom()
      }, 1000)
    }
  }

  addMessage(text, role) {
    const messageElement = document.createElement("div")
    messageElement.className = `py-8 ${role === "user" ? "bg-gray-50 dark:bg-gray-900" : ""}`

    const messageContent = document.createElement("div")
    messageContent.className = "max-w-3xl mx-auto px-4"

    const messageWrapper = document.createElement("div")
    messageWrapper.className = "flex items-start space-x-4"

    const avatar = document.createElement("div")
    avatar.className = `flex-shrink-0 w-8 h-8 rounded-full ${role === "user" ? "bg-indigo-600" : "bg-green-500"} flex items-center justify-center`
    avatar.innerHTML = `<span class="text-white font-bold">${role === "user" ? "U" : "AI"}</span>`

    const content = document.createElement("div")
    content.className = "flex-1 min-w-0"

    const name = document.createElement("p")
    name.className = "text-sm font-medium text-gray-900 dark:text-white"
    name.textContent = role === "user" ? "Tú" : "Hireminator"

    const messageText = document.createElement("p")
    messageText.className = "text-sm text-gray-500 dark:text-gray-400"
    messageText.textContent = text

    content.appendChild(name)
    content.appendChild(messageText)
    messageWrapper.appendChild(avatar)
    messageWrapper.appendChild(content)
    messageContent.appendChild(messageWrapper)
    messageElement.appendChild(messageContent)

    this.messagesTarget.appendChild(messageElement)
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
