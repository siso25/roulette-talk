import { Controller } from '@hotwired/stimulus'
import { save } from '../helpers/storage'

export default class extends Controller {
  static outlets = ['roulette']

  reset() {
    save(
      'talk',
      this.createLotteryString(this.rouletteOutlet.talkThemeTargets.length)
    )
    save(
      'speaker',
      this.createLotteryString(this.rouletteOutlet.speakerNameTargets.length)
    )
  }

  private

  createLotteryString(elementCount) {
    const numbers = []
    for (let i = 0; i < elementCount; i++) {
      numbers.push(i)
    }

    return numbers
  }
}
