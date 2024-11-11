import { Controller } from "@hotwired/stimulus"
import Iro from '@jaames/iro';

export default class extends Controller {
  connect() {
    const lessonColor = document.getElementById("color-picker-container").getAttribute("data-lesson-color") || "#ff8d21";
    this.colorPicker = new Iro.ColorPicker("#color-picker-container", {
      width: 150,
      color: lessonColor
    });

    this.element.querySelector("#color-value").value = this.hexToRgba(lessonColor, 0.6)

    this.colorPicker.on('color:change', (color) => {
      const colorWithOpacity = `rgba(${color.rgb.r}, ${color.rgb.g}, ${color.rgb.b}, 0.6)`;
      this.setColorValue(colorWithOpacity);
    });
  }

  setColorValue(rgba) {
    this.element.querySelector("#color-value").value = rgba;
  }

  hexToRgba(hex, alpha = 1) {
    hex = hex.replace(/^#/, '');
  
    let r = parseInt(hex.slice(0, 2), 16);
    let g = parseInt(hex.slice(2, 4), 16);
    let b = parseInt(hex.slice(4, 6), 16);
  
    return `rgba(${r}, ${g}, ${b}, ${alpha})`;
  }
}
