import { Controller } from '@hotwired/stimulus'
import { save } from '../helpers/storage'

export default class extends Controller {
  static targets = ['talkTheme', 'speakerName']

  connect() {
    this.reset()
  }

  reset() {
    save('talk', this.createLotteryString(this.talkThemeTargets.length))
    save('speaker', this.createLotteryString(this.speakerNameTargets.length))
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
