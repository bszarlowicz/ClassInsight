import { Controller } from "@hotwired/stimulus";

import Calendar from "tui-calendar";
import TuiCodeSnippet from "tui-code-snippet";
import TuiDatePicker from "tui-date-picker";
import TuiTimePicker from "tui-time-picker";

export default class extends Controller {
  static targets = ["currentMonth"];
  connect() {
    console.log('calendar here!')
    this.displayCalendar();
  }

  displayCalendar(){
    this.calendar = new Calendar('#calendar', {
      id: '1',
      defaultView: 'week',
      isReadOnly: true,
      taskView: false,
      scheduleView: ['time'],
      week:{
        hourStart: 7,
        hourEnd: 22,
        narrowWeekend: true,
        startDayOfWeek: 1,
      },
      template: {
        weekDayname: function(dayNameModel) {
          const date = new Date(dayNameModel.renderDate);
          const day = date.getDate().toString().padStart(2, '0');
          const month = (date.getMonth() + 1).toString().padStart(2, '0');
          const weekday = date.toLocaleDateString('pl-PL', { weekday: 'short' });
      
          return `<span class="date-number">${day}.${month}</span> <span class="day-name">${weekday}</span>`;
        },
        timegridDisplayPrimaryTime: function(time) {
            var hour = time.hour;
            var minutes = time.minutes < 10 ? '0' + time.minutes : time.minutes;
            return hour + ':' + minutes;
        }
      }
    });
    this.updateMonthDisplay();

    const lessons = JSON.parse(document.getElementById('calendar').getAttribute('data-lessons'));

    console.log(lessons)
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

  disconnect() {
    if (this.calendar) {
      this.calendar.destroy();
      this.calendar = null;
    }
  }
}
