import { Controller } from "@hotwired/stimulus"
import { getLotteryTargets, createLotteryTargets } from "../helpers/local_storage"

export default class extends Controller {
  execute() {
    const talkTargets = getLotteryTargets('talk')
    const position = this.lottery(talkTargets)
    const animation = this.rotate(talkTargets[position], 'roulette', 2800)
    const speakerTargets = getLotteryTargets('speaker')
    const position2 = this.lottery(speakerTargets)
    const animation2 = this.rotate(speakerTargets[position2], 'roulette2', 3000)

    Promise.all([animation.finished, animation2.finished]).then(() => {
      this.deleteTarget(talkTargets, position)
      createLotteryTargets('talk', talkTargets)
      this.deleteTarget(speakerTargets, position2)
      createLotteryTargets('speaker', speakerTargets)
    })
  }

  private

  rotate(stopping_position, element_id, duration_time) {
    const element = document.getElementById(element_id)
    const rotateDeg = 90
    const endDeg = 360 * 9 - rotateDeg * stopping_position + this.stopPosition(rotateDeg)
    const animation = element.animate(
      [
        { transform: 'rotate(0)' },
        { transform: `rotate(${endDeg}deg)` }
      ],
      {
        duration: duration_time,
        easing: "cubic-bezier(0,0.4,.3,1)",
        fill: "forwards"
      }
    );
    return animation
  }

  stopPosition(deg) {
    const max = deg - 1
    const min = 1
    return Math.floor(Math.random() * (max - min) + min) - deg / 2
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
