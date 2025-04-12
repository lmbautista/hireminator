import "@hotwired/turbo-rails"
import "./controllers"
import "../stylesheets/application.css"


document.getElementById('dark-toggle').addEventListener('click', () => {
  document.documentElement.classList.toggle('dark')
})
