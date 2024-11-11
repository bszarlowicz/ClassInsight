import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    const lessonHour = document.getElementById("lesson-hour").getAttribute("data-lesson-hour") || "12:00";
    flatpickr(".time-picker", {
      enableTime: true,
      noCalendar: true,
      dateFormat: "H:i",
      time_24hr: true,
      minTime: "07:00",
      maxTime: "22:00",
      defaultDate: lessonHour
    });
  }
}
