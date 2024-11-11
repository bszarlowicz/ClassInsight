import { Controller } from "@hotwired/stimulus";

import Calendar from "tui-calendar";
import TuiCodeSnippet from "tui-code-snippet";
import TuiDatePicker from "tui-date-picker";
import TuiTimePicker from "tui-time-picker";

export default class extends Controller {
  static targets = ["currentMonth"];
  connect() {
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
    this.loadEvents();
  }

  loadEvents() {
    const lessons = JSON.parse(document.getElementById('calendar').getAttribute('data-lessons'));
    const schedules = lessons.flatMap(lesson => {
      const startTime = new Date(lesson.hour);
      const [hours, minutes] = [startTime.getUTCHours(), startTime.getUTCMinutes()];

      return lesson.occurrences.map(dateString => {
        const date = new Date(dateString);
        date.setHours(hours, minutes, 0, 0);

        const end = new Date(date);
        end.setHours(date.getHours() + 1);

        return {
          id: `lesson-${lesson.id}-${dateString}`,
          calendarId: '1',
          title: 'Lesson',
          category: 'time',
          start: date,
          end: end,
          isReadOnly: true,
          bgColor: lesson.color,
          borderColor: this.darkenRgbaColor(lesson.color)
        };
      });
    });

    this.calendar.createSchedules(schedules);
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

  prev() {
    this.calendar.prev();
    this.updateMonthDisplay();
  }

  next() {
    this.calendar.next();
    this.updateMonthDisplay();
  }

  capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  }

  darkenRgbaColor(rgba, amount = 0.1) {
    let rgbaValues = rgba.match(/^rgba\((\d+), (\d+), (\d+), ([0-9.]+)\)$/);
  
    let r = parseInt(rgbaValues[1], 10);
    let g = parseInt(rgbaValues[2], 10);
    let b = parseInt(rgbaValues[3], 10);
    let a = parseFloat(rgbaValues[4]);
  
    r = Math.floor(r * (1 - amount));
    g = Math.floor(g * (1 - amount));
    b = Math.floor(b * (1 - amount));

    return `rgba(${r}, ${g}, ${b}, ${a})`;
  }

  disconnect() {
    if (this.calendar) {
      this.calendar.destroy();
      this.calendar = null;
    }
  }
}
