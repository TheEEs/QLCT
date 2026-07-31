import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { current: String }

  connect() {
    const storedLocale = localStorage.getItem("locale")
    
    // If we have a stored locale in localStorage, but it doesn't match the current server-rendered locale,
    // we should sync it by navigating to the page with the stored locale.
    if (storedLocale && storedLocale !== this.currentValue) {
      this.switchLocale(storedLocale)
    }
  }

  change(event) {
    event.preventDefault()
    const newLocale = event.currentTarget.dataset.locale
    this.switchLocale(newLocale)
  }

  switchLocale(locale) {
    localStorage.setItem("locale", locale)
    document.cookie = `locale=${locale}; path=/; max-age=31536000; SameSite=Lax`
    
    // Construct new URL with the locale parameter
    const url = new URL(window.location.href)
    url.searchParams.set("locale", locale)
    
    // Navigate to the new URL
    window.location.href = url.pathname + url.search
  }
}
