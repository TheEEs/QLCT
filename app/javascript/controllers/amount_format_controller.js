import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "visible", "hidden" ]
  static values = {
    separator: { type: String, default: "." }
  }

  connect() {
    this.syncFromHidden()
  }

  syncFromHidden() {
    if (this.hasHiddenTarget && this.hasVisibleTarget) {
      const rawValue = this.hiddenTarget.value
      if (rawValue) {
        this.visibleTarget.value = this.format(rawValue)
      }
    }
  }

  formatInput(event) {
    const input = this.visibleTarget
    const selectionStart = input.selectionStart
    const originalValue = input.value
    
    // Count how many non-digits (like dots, commas, underscores) were before the selection cursor originally
    const nonDigitsBeforeCursor = (originalValue.substring(0, selectionStart).match(/\D/g) || []).length
    
    // Extract only digits
    const rawValue = originalValue.replace(/\D/g, "")
    
    if (rawValue === "") {
      input.value = ""
      this.hiddenTarget.value = ""
      return
    }
    
    const formattedValue = this.format(rawValue)
    input.value = formattedValue
    this.hiddenTarget.value = rawValue
    
    // Calculate new cursor position to keep typing smooth
    const digitsBeforeCursor = selectionStart - nonDigitsBeforeCursor
    
    let newSelectionStart = 0
    let digitCount = 0
    const separator = this.separatorValue
    
    for (let i = 0; i < formattedValue.length; i++) {
      if (formattedValue[i] !== separator) {
        digitCount++
      }
      if (digitCount > digitsBeforeCursor) {
        newSelectionStart = i
        break
      }
      newSelectionStart = i + 1
    }
    
    input.setSelectionRange(newSelectionStart, newSelectionStart)
  }

  format(value) {
    if (!value) return ""
    // Ensure value is clean of non-digits
    const cleanValue = value.toString().replace(/\D/g, "")
    // Insert the separator every 3 digits from right to left
    const regex = new RegExp(`\\B(?=(\\d{3})+(?!\\d))`, "g")
    return cleanValue.replace(regex, this.separatorValue)
  }
}
