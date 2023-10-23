import { Controller } from "@hotwired/stimulus"
import { saveTargets, getTargets } from "../helpers/storage"

export default class extends Controller {
  static targets = ['talk', 'speaker']

  start() {
    const talkAnimation = this.rotate(this.talkTarget, 'talk', 2800)
    const speakerAnimation = this.rotate(this.speakerTarget, 'speaker', 3000)

    Promise.all([talkAnimation.finished, speakerAnimation.finished]).then(() => {
      console.log('finished')
    })
  }

  private

  rotate(roulette, rouletteName, duration_time) {
    const lotteryTargets = getTargets(rouletteName)
    const lotteryResult = this.lottery(lotteryTargets)
    const rotateDeg = 90
    const endDeg = 360 * 9 - rotateDeg * lotteryResult + this.stoppingPosition(rotateDeg)
    const animation = roulette.animate(
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

  stoppingPosition(deg) {
    const max = deg - 1
    const min = 1
    return this.createRandomInt(max, min) - deg / 2
  }

  lottery(targets) {
    const max = targets.length
    const min = 0
    return this.createRandomInt(max, min)
  }

  createRandomInt(max, min) {
    return Math.floor(Math.random() * (max - min) + min)
  }

  deleteTarget(rouletteName, targets, index) {
    targets.splice(index, 1)
    saveTargets(rouletteName, targets)
  }
}
