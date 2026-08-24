import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tierField"]

  connect() {
    this.updateVisibility()
  }

  togglePaidFields(event) {
    this.updateVisibility()
  }

  updateVisibility() {
    const select = this.element.querySelector("select[name='post[paid]']")
    const tierField = this.tierFieldTarget

    if (select && tierField) {
      if (select.value === "true") {
        tierField.style.display = "block"
      } else {
        tierField.style.display = "none"
      }
    }
  }
}