import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const colors = ["#ffcd90", "#ff8d21", "#ff7b00", "ffa652"];
    const numBalls = 120;
    const balls = [];

    const container = this.element;
    const containerWidth = container.offsetWidth;
    const containerHeight = container.offsetHeight;

    for (let i = 0; i < numBalls; i++) {
      let ball = document.createElement("div");
      ball.classList.add("ball");
      ball.style.background = colors[Math.floor(Math.random() * colors.length)];
      ball.style.left = `${Math.floor(Math.random() * containerWidth)}px`;
      ball.style.top = `${Math.floor(Math.random() * containerHeight)}px`;

      const size = Math.random() * 0.3;
      ball.style.width = `${size}em`;
      ball.style.height = `${size}em`;

      balls.push(ball);
      container.append(ball);
    }

    balls.forEach((el, i) => {
      let to = {
        x: Math.random() * (i % 2 === 0 ? -11 : 11),
        y: Math.random() * 12
      };

      el.animate(
        [
          { transform: "translate(0, 0)" },
          { transform: `translate(${to.x}rem, ${to.y}rem)` }
        ],
        {
          duration: (Math.random() + 1) * 2000,
          direction: "alternate",
          fill: "both",
          iterations: Infinity,
          easing: "ease-in-out"
        }
      );
    });
  }
}
