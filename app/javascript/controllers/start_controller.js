import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="start"
export default class extends Controller {
  execute() {
    const position = Math.floor(Math.random() * (4 - 1) + 1)
    const animation = this.rotate(position)
    animation.finished.then(() => {
      cosole.log('finish')
    })
  }

  rotate(stopping_position) {
    const element = document.getElementById('roulette')
    console.log(element)
    const endDeg = 360 * 9 - 90 * stopping_position + 45
    const animation = element.animate(
      [
        { transform: 'rotate(0)' },
        { transform: `rotate(${endDeg}deg)` }
      ],
      {
        duration: 1800,
        easing: "cubic-bezier(0.83, 0, 0.17, 1)",
        // easing: "cubic-bezier(0, 0.4, 0.4, 1)",
        fill: "forwards"
      }
    );
    return animation
  }
}
