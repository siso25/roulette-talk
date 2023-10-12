import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="start"
export default class extends Controller {
  execute() {
    const position = Math.floor(Math.random() * (4 - 1) + 1)
    const animation = this.rotate(position, 'roulette', 1800)
    animation.finished.then(() => {
      console.log('talk theme finish')
    })
    const position2 = Math.floor(Math.random() * (4 - 1) + 1)
    const animation2 = this.rotate(position2, 'roulette2', 2000)
    animation2.finished.then(() => {
      console.log('speaker finish')
    })
  }

  rotate(stopping_position, element_id, duration_time) {
    const element = document.getElementById(element_id)
    console.log(element)
    const endDeg = 360 * 9 - 90 * stopping_position + 45
    const animation = element.animate(
      [
        { transform: 'rotate(0)' },
        { transform: `rotate(${endDeg}deg)` }
      ],
      {
        duration: duration_time,
        easing: "cubic-bezier(0.83, 0, 0.17, 1)",
        // easing: "cubic-bezier(0, 0.4, 0.4, 1)",
        fill: "forwards"
      }
    );
    return animation
  }
}
