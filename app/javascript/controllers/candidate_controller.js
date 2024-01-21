import { Controller } from '@hotwired/stimulus'
import { resetLotteryCandidates } from '../helpers/storage'

export default class extends Controller {
  static outlets = ['roulette']

  reset() {
    resetLotteryCandidates('talk', this.rouletteOutlet.talkThemeTargets)
    resetLotteryCandidates('speaker', this.rouletteOutlet.speakerNameTargets)
  }
}
