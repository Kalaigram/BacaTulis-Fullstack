import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form", "reportableType", "reportableId", "dropdown", "list"]

  showModal(event) {
    const button = event.currentTarget
    this.reportableTypeTarget.value = button.dataset.reportReportableTypeValue
    this.reportableIdTarget.value = button.dataset.reportReportableIdValue
    this.modalTarget.showModal()
  }

  hideModal() {
    this.modalTarget.close()
  }
}