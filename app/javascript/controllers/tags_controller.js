import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form", "reportableType", "reportableId"]

  showModal(event) {
    const button = event.currentTarget
    this.reportableTypeTarget.value = button.dataset.reportReportableTypeValue
    this.reportableIdTarget.value = button.dataset.reportReportableIdValue
    this.modalTarget.showModal()
  }

  hideModal() {
    this.modalTarget.close()
  }

  addTag(event) {
    if (event.key === "Enter") {
      event.preventDefault()
      const input = this.tagInputTarget
      const tagName = input.value.trim()
      if (!tagName) return

      this.createTag(tagName)
      input.value = ""
    }
  }

  async createTag(name) {
    const response = await fetch(this.urlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Accept": "application/json"
      },
      body: JSON.stringify({ tag: { name } })
    })

    if (response.ok) {
      const data = await response.json()
      this.addTagChip(data.tag)
    }
  }

  addTagChip(tag) {
    const chipsContainer = this.tagChipsTarget
    const chip = document.createElement("span")
    chip.className = "badge badge-primary badge-sm flex items-center gap-1"
    chip.innerHTML = `
      ${tag.name}
      <input type="hidden" name="post[tag_ids][]" value="${tag.id}">
      <button type="button" class="btn btn-xs btn-ghost" data-action="click->tags#removeTag" data-tag-id-value="${tag.id}">×</button>
    `
    chipsContainer.appendChild(chip)
  }

  removeTag(event) {
    const tagId = event.currentTarget.dataset.tagIdValue
    const chip = event.currentTarget.closest(".badge")
    if (chip) chip.remove()
  }

  static get values() {
    return {
      url: String,
      tagChips: String,
      tagInput: String
    }
  }
}