import { Controller } from '@hotwired/stimulus';
import Splide from '@splidejs/splide';

export default class extends Controller {
  connect() {
    const splide = new Splide( '.splide', {
      direction: 'ttb',
      height: '10rem',
      wheel: true,
      releaseWheel: true,
      autoplay: true,
    } );

    splide.mount();
  }
}