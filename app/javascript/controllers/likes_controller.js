import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    destroyUrl: String,
    count: Number
  }

  async toggle(event) {
    event.preventDefault()

    if (this.destroyUrlValue) {
      // Unlike
      const response = await fetch(this.destroyUrlValue, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
          "Accept": "text/vnd.turbo-stream.html"
        }
      })
    } else {
      // Like
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