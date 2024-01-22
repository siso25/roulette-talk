import { Controller } from '@hotwired/stimulus'
import { resetLotteryCandidates } from '../helpers/storage'

export default class extends Controller {
  static targets = ['talkTheme', 'speakerName']

  connect() {
    resetLotteryCandidates('talk', this.talkThemeTargets)
    resetLotteryCandidates('speaker', this.speakerNameTargets)
  }
}
