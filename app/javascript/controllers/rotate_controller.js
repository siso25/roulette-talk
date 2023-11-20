import { Controller } from "@hotwired/stimulus"
import { saveTargets, save, getTargets, find } from "../helpers/storage"

export default class extends Controller {
  static targets = ['result', 'talk', 'talkTheme', 'speaker', 'speakerName', 'startButton', 'resetButton']

  start() {
    this.startButtonTarget.disabled = true
    this.resetButtonTarget.disabled = true
    this.resultTarget.value = ''
    const talkAnimation = this.rotate(this.talkTarget, this.talkThemeTargets, 'talk', 2800)
    const speakerAnimation = this.rotate(this.speakerTarget, this.speakerNameTargets, 'speaker', 3000)

    Promise.all([talkAnimation.finished, speakerAnimation.finished]).then(() => {
      this.startButtonTarget.disabled = false
      this.resetButtonTarget.disabled = false
      this.resultTarget.innerText = `トークテーマは「${find('talkResult')}」話すのは「${find('speakerResult')}」さんです。`
    })
  }

  private

  rotate(roulette, rouletteItems, rouletteName, duration_time) {
    const lotteryTargets = getTargets(rouletteName)
    const lotteryResultIndex = this.lottery(lotteryTargets)
    const lotteryResult = lotteryTargets[lotteryResultIndex]
    save(`${rouletteName}Result`, rouletteItems[lotteryResult].innerText)
    this.deleteTarget(rouletteName, lotteryTargets, lotteryResultIndex)
    const rotateDeg = 360 / rouletteItems.length
    const endDeg = 360 * 9 + (90 - rotateDeg + rotateDeg / 2) - rotateDeg * lotteryResult + this.stoppingPosition(rotateDeg)
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
