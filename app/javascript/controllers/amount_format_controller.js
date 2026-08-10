import { Controller } from "@hotwired/stimulus"

const NON_DIGIT_REGEX = /\D/g
const THOUSAND_SEPARATOR_REGEX = /\B(?=(\d{3})+(?!\d))/g
const DIGIT_REGEX = /\d/g

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
    const hiddenTarget = this.hiddenTarget 
    
    const rawValue = originalValue.replace(NON_DIGIT_REGEX, "")
    
    if (rawValue === ""){
      input.value = ""
      hiddenTarget.value = ""
      return
    }

    const formattedValue = this.format(rawValue)

    const numbersBeforeCursor = (originalValue.substring(0, selectionStart).match(DIGIT_REGEX) || []).length
    const numbersAfterCursor = rawValue.length - numbersBeforeCursor

    const totalSeparators = Math.floor((rawValue.length - 1)/3)
    const separatorsAfterCursor = Math.floor(numbersAfterCursor / 3)

    const separatorsBeforeCursor = Math.max(totalSeparators - separatorsAfterCursor, 0)

    const newCursorPosition = numbersBeforeCursor + separatorsBeforeCursor * this.separatorValue.length

    input.value = formattedValue
    hiddenTarget.value = rawValue
    input.setSelectionRange(newCursorPosition, newCursorPosition)
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
