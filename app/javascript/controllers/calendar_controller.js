import { Controller } from "@hotwired/stimulus";

import Calendar from "tui-calendar";
import TuiCodeSnippet from "tui-code-snippet";
import TuiDatePicker from "tui-date-picker";
import TuiTimePicker from "tui-time-picker";

export default class extends Controller {
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
  }
}
