import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dayButton"]

  toggle(event) {
    const checkbox = event.target
    const dayButton = checkbox.closest(".day-button")

    if (checkbox.checked) {
      dayButton.classList.add("selected")
    } else {
      dayButton.classList.remove("selected")
    }
  }

  connect() {
    this.updateSelectedClass()
  }

  updateSelectedClass() {
    this.dayButtonTargets.forEach((dayButton) => {
      const checkbox = dayButton.querySelector("input[type='checkbox']")
      if (checkbox && checkbox.checked) {
        dayButton.classList.add("selected")
      } else {
        dayButton.classList.remove("selected")
      }
    });
  }
}