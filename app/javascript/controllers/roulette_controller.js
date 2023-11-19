import { Controller } from "@hotwired/stimulus"
import { saveTargets } from "../helpers/storage"

export default class extends Controller {
  static targets = ['talkTheme', 'speakerName']

  connect() {
    this.reset()
  }

  reset() {
    saveTargets('talk', this.createLotteryString(this.talkThemeTargets.length))
    saveTargets('speaker', this.createLotteryString(this.speakerNameTargets.length))
  }

  private

  createLotteryString(element_count) {
    let numbers = []
    for (let i = 0; i < element_count; i++) {
      numbers.push(i)
    }

    return numbers.join()
  }
}
