import { Controller } from '@hotwired/stimulus'
import { save, findByKey } from '../helpers/storage'

export default class extends Controller {
  static outlets = ['roulette-items']

  static targets = [
    'resultText',
    'talkThemeResult',
    'speakerResult',
    'talk',
    'talkTheme',
    'speaker',
    'speakerName',
    'startButton',
    'resetButton'
  ]

  start() {
    this.startButtonTarget.disabled = true
    this.resetButtonTarget.disabled = true
    this.resultTextTarget.style.visibility = 'hidden'
    const talkAnimation = this.rotate(
      this.talkTarget,
      this.talkThemeTargets,
      'talk',
      2800
    )
    const speakerAnimation = this.rotate(
      this.speakerTarget,
      this.speakerNameTargets,
      'speaker',
      3000
    )

    Promise.all([talkAnimation.finished, speakerAnimation.finished]).then(
      () => {
        this.startButtonTarget.disabled = false
        this.resetButtonTarget.disabled = false
        this.talkThemeResultTarget.innerText = findByKey('talkResult')
        this.speakerResultTarget.innerText = findByKey('speakerResult')
        this.resultTextTarget.style.visibility = 'visible'
        this.rouletteItemsOutlets.forEach(element => element.changeBackgroundColor())
      }
    )
  }

  private

  rotate(roulette, rouletteItems, rouletteName, durationTime) {
    const storageTartgets = findByKey(rouletteName)
    const lotteryTargets =
      storageTartgets.length !== 0
        ? storageTartgets
        : this.createLotteryString(rouletteItems.length)
    const lotteryResultIndex = this.lottery(lotteryTargets)
    const lotteryResult = lotteryTargets[lotteryResultIndex]
    save(`${rouletteName}ResultIndex`, lotteryResultIndex)
    save(`${rouletteName}Result`, rouletteItems[lotteryResult].innerText)
    this.deleteTarget(rouletteName, lotteryTargets, lotteryResultIndex)
    const rotateDeg = 360 / rouletteItems.length
    const endDeg =
      360 * 9 +
      (90 - rotateDeg + rotateDeg / 2) -
      rotateDeg * lotteryResult +
      this.stoppingPosition(rotateDeg)
    const animation = roulette.animate(
      [{ transform: 'rotate(0)' }, { transform: `rotate(${endDeg}deg)` }],
      {
        duration: durationTime,
        easing: 'cubic-bezier(0,0.4,.3,1)',
        fill: 'forwards'
      }
    )
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
    save(rouletteName, targets)
  }

  createLotteryString(elementCount) {
    const numbers = []
    for (let i = 0; i < elementCount; i++) {
      numbers.push(i)
    }

    return numbers
  }
}
