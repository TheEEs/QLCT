import { Controller } from "@hotwired/stimulus"

const NON_DIGIT_REGEX = /\D/g
const THOUSAND_SEPARATOR_REGEX = /\B(?=(\d{3})+(?!\d))/g
const DIGIT_REGEX = /\d/g

export default class extends Controller {
  static targets = ["visible", "hidden"]
  static values = {
    separator: { type: String, default: "." }
  }

  connect() {
    this.syncFromHidden()
  }

  /**
   * Synchronizes the visible input field with the value from the hidden input field.
   * This is typically called on connection to format the initial value loaded from the backend.
   */
  syncFromHidden() {
    if (this.hasHiddenTarget && this.hasVisibleTarget) {
      const rawValue = this.hiddenTarget.value
      if (rawValue) {
        this.visibleTarget.value = this.format(rawValue)
      }
    }
  }

  /**
   * Event handler that formats the visible input field on input, updates the hidden input
   * with the raw digit value, and carefully preserves the cursor position.
   */
  formatInput(event) {
    if (!this.hasVisibleTarget || !this.hasHiddenTarget) return

    const input = this.visibleTarget
    const originalValue = input.value
    const selectionStart = input.selectionStart
    const hiddenTarget = this.hiddenTarget

    // Extract only digits from the user's raw input
    const rawValue = originalValue.replace(NON_DIGIT_REGEX, "")

    // If input is empty, clear both fields and abort
    if (rawValue === "") {
      input.value = ""
      hiddenTarget.value = ""
      return
    }

    const formattedValue = this.format(rawValue, false)

    // Calculate the new cursor position to prevent jumping:
    // 1. Count how many digits exist to the left of the cursor before formatting.
    const numbersBeforeCursor = (originalValue.substring(0, selectionStart).match(DIGIT_REGEX) || []).length
    // 2. Count how many digits exist to the right of the cursor.
    const numbersAfterCursor = rawValue.length - numbersBeforeCursor

    // 3. Since thousands separators are anchored from the right of the string,
    //    we calculate how many total separators will exist in the formatted string.
    const totalSeparators = Math.floor((rawValue.length - 1) / 3)
    // 4. Calculate how many separators will be placed to the right of the cursor.
    const separatorsAfterCursor = Math.floor(numbersAfterCursor / 3)

    // 5. The remaining separators must be to the left of the cursor.
    const separatorsBeforeCursor = Math.max(totalSeparators - separatorsAfterCursor, 0)

    // 6. The new cursor index is the number of digits before the cursor
    //    plus the total width of all separators that are inserted before the cursor.
    const newCursorPosition = numbersBeforeCursor + separatorsBeforeCursor * this.separatorValue.length

    // Update targets and restore cursor position
    input.value = formattedValue
    hiddenTarget.value = rawValue
    input.setSelectionRange(newCursorPosition, newCursorPosition)
  }

  /**
   * Formats a raw digit string or number with thousands separators.
   * 
   * @param {string|number} value - The raw value to format.
   * @param {boolean} [clean=true] - Whether to strip non-digit characters from the value first.
   * @returns {string} The formatted string with thousands separators.
   */
  format(value, clean = true) {
    if (!value) return ""
    
    // Ensure value is clean of non-digits
    const cleanValue = clean ? value.toString().replace(NON_DIGIT_REGEX, "") : value.toString()
    
    // Insert the separator every 3 digits from right to left.
    // Using a callback function prevents special regex replacement patterns (like "$&" or "$$") 
    // in this.separatorValue from corrupting the result.
    return cleanValue.replace(THOUSAND_SEPARATOR_REGEX, () => this.separatorValue)
  }
}
