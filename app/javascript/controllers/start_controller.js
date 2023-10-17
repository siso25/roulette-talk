import { Controller } from "@hotwired/stimulus"
import { getLotteryTargets, createLotteryTargets } from "../helpers/local_storage"

export default class extends Controller {
  execute() {
    const talkTargets = getLotteryTargets('talk')
    const position = this.lottery(talkTargets)
    const animation = this.rotate(talkTargets[position], 'roulette', 1800)
    animation.finished.then(() => {
      console.log('talk theme finish')
      this.deleteTarget(talkTargets, position)
      createLotteryTargets('talk', talkTargets)
    })

    const speakerTargets = getLotteryTargets('speaker')
    const position2 = this.lottery(speakerTargets)
    const animation2 = this.rotate(speakerTargets[position2], 'roulette2', 2000)
    animation2.finished.then(() => {
      console.log('speaker finish')
      this.deleteTarget(speakerTargets, position2)
      createLotteryTargets('speaker', speakerTargets)
    })
  }

  rotate(stopping_position, element_id, duration_time) {
    const element = document.getElementById(element_id)
    const endDeg = 360 * 9 - 90 * stopping_position + 45
    const animation = element.animate(
      [
        { transform: 'rotate(0)' },
        { transform: `rotate(${endDeg}deg)` }
      ],
      {
        duration: duration_time,
        easing: "cubic-bezier(0, 0.4, 0.4, 1)",
        fill: "forwards"
      }
    );
    return animation
  }

  lottery(targets) {
    const max = targets.length
    const min = 0
    return Math.floor(Math.random() * (max - min) + min)
  }

  deleteTarget(targets, position) {
    targets.splice(position, 1)
    return targets
  }
}
