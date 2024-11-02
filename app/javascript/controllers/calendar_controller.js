import { Controller } from "@hotwired/stimulus";

import Calendar from "tui-calendar";
import TuiCodeSnippet from "tui-code-snippet";
import TuiDatePicker from "tui-date-picker";
import TuiTimePicker from "tui-time-picker";

export default class extends Controller {
  static targets = ["currentMonth"];
  connect() {
    console.log('calendar here!')
    const daysOfWeek = JSON.parse(this.element.dataset.dayNames);
    this.calendar = new Calendar('#calendar', {
      id: '1',
      defaultView: 'week',
      isReadOnly: true,
      taskView: false,
      scheduleView: ['time'],
      week:{
        hourStart: 7,
        hourEnd: 22,
        daynames: daysOfWeek,
        narrowWeekend: true,
        startDayOfWeek: 1,
        
      },
      template: {
        timegridDisplayPrimaryTime: function(time) {
            var hour = time.hour;
            var minutes = time.minutes < 10 ? '0' + time.minutes : time.minutes;
            return hour + ':' + minutes;
        }
      }
    });
    this.updateMonthDisplay();
  }

  prev() {
    this.calendar.prev();
    this.updateMonthDisplay();
  }

  next() {
    this.calendar.next();
    this.updateMonthDisplay();
  }

  updateMonthDisplay() {
    const startDate = this.calendar.getDateRangeStart().toDate();
    const endDate = this.calendar.getDateRangeEnd().toDate();

    const startMonth = this.capitalizeFirstLetter(startDate.toLocaleString('default', { month: 'long' }));
    const startYear = startDate.getFullYear();
    const endMonth = this.capitalizeFirstLetter(endDate.toLocaleString('default', { month: 'long' }));
    const endYear = endDate.getFullYear();

    let displayText;

    if (startMonth === endMonth && startYear === endYear) {
      displayText = `${startMonth} ${startYear}`;
    } else if (startYear === endYear) {
      displayText = `${startMonth}/${endMonth} ${startYear}`;
    } else {
      displayText = `${startMonth} ${startYear} / ${endMonth} ${endYear}`;
    }
    this.currentMonthTarget.textContent = displayText;
  }

  capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  }
}
