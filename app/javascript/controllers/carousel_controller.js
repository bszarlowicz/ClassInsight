import { Controller } from "@hotwired/stimulus";
import * as bootstrap from 'bootstrap';

export default class extends Controller {
  connect() {
    this.startCarousel();
  }

  startCarousel() {
    const carouselElement = this.element.querySelector('#carouselAuto');

    if (carouselElement) {
      const bsCarousel = new bootstrap.Carousel(carouselElement, {
        interval: 7000
      });

      bsCarousel.cycle();
    }
  }
}
