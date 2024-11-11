import { Controller } from "@hotwired/stimulus"
import Iro from '@jaames/iro';

export default class extends Controller {
  connect() {
    const lessonColor = document.getElementById("color-picker-container").getAttribute("data-lesson-color") || "rgba(255, 141, 33, 0.6)";
    this.colorPicker = new Iro.ColorPicker("#color-picker-container", {
      width: 352,
      color: lessonColor,
      layout: [
        {
          component: Iro.ui.Slider,
          options: {
            sliderType: 'hue'
          }
        },
      ]
    });

    this.element.querySelector("#color-value").value = lessonColor, 0.6

    this.colorPicker.on('color:change', (color) => {
      const colorWithOpacity = `rgba(${color.rgb.r}, ${color.rgb.g}, ${color.rgb.b}, 0.6)`;
      this.setColorValue(colorWithOpacity);
    });
  }

  setColorValue(rgba) {
    this.element.querySelector("#color-value").value = rgba;
  }
}
