import { Controller } from '@hotwired/stimulus'
import { resetLotteryCandidates } from '../helpers/storage'

export default class extends Controller {
  static outlets = ['roulette-items']
  static targets = ['talkTheme', 'speakerName']

  connect() {
    resetLotteryCandidates('talk', this.talkThemeTargets)
    resetLotteryCandidates('speaker', this.speakerNameTargets)
    this.rouletteItemsOutlets.forEach((element) =>
      element.resetBackgroundColor()
    )
  }
}
