import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "list"]
  static values = {
    count: Number
  }

  load() {
    // Load notifications when dropdown opens
    // Could add polling here
  }

  async markAsRead(event) {
    const notificationId = event.currentTarget.dataset.notificationIdValue
    if (!notificationId) return

    await fetch(`/notifications/${notificationId}/mark_as_read`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      }
    })
  }
}