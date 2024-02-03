import { Controller } from '@hotwired/stimulus'
import { resetLotteryCandidates } from '../helpers/storage'

export default class extends Controller {
  static outlets = ['roulette', 'roulette-items']

  reset() {
    resetLotteryCandidates('talk', this.rouletteOutlet.talkThemeTargets)
    resetLotteryCandidates('speaker', this.rouletteOutlet.speakerNameTargets)
    this.rouletteItemsOutlets.forEach((element) =>
      element.removeAllStrikethrough()
    )
  }
}
