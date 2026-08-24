import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    destroyUrl: String
  }

  async toggle(event) {
    event.preventDefault()

    if (this.destroyUrlValue) {
      // Remove bookmark
      const response = await fetch(this.destroyUrlValue, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
          "Accept": "text/vnd.turbo-stream.html"
        }
      })
    } else {
      // Add bookmark
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
          "Accept": "text/vnd.turbo-stream.html"
        }
      })
    }
  }
}