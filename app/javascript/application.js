// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { themeChange } from "theme-change"

// Initialize theme-change on page load and subsequent Turbo loads
document.addEventListener("turbo:load", () => {
  themeChange(false)
})

