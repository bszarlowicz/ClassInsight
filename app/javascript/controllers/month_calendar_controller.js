import { Controller } from "@hotwired/stimulus"
import Calendar from "tui-calendar";

// Connects to data-controller="month-calendar"
export default class extends Controller {
  static targets = ["currentMonth"];
  connect() {
    this.displayCalendar();
  }

  displayCalendar(){
    this.calendar = new Calendar('#calendar', {
      id: '1',
      defaultView: 'month',
      isReadOnly: true,
      taskView: false,
      scheduleView: ['time'],
      month:{
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
        },
        time: function(schedule) {
          return schedule.title;
        }
      }
    });
    this.updateMonthDisplay();
    this.loadEvents();
  }

  loadEvents() {
    const lessons = JSON.parse(document.getElementById('calendar').getAttribute('data-lessons'));
    const eventCounts = {};
  
    // Przechodzimy przez lekcje i ich wystąpienia
    lessons.forEach(lesson => {
      lesson.occurrences.forEach(dateString => {
        // Zliczamy wydarzenia w danym dniu
        if (!eventCounts[dateString]) {
          eventCounts[dateString] = 0;
        }
        eventCounts[dateString] += 1;
      });
    });
  
    // Tworzymy wydarzenia z liczbą eventów na dzień
    const schedules = Object.keys(eventCounts).map(dateString => {
      const date = new Date(dateString);
      return {
        id: `events-${dateString}`,
        calendarId: '1',
        title: `${eventCounts[dateString]}`,
        category: 'allday',
        start: date,
        end: date,
        isReadOnly: true,
      };
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

  disconnect() {
    if (this.calendar) {
      this.calendar.destroy();
      this.calendar = null;
    }
  }
}