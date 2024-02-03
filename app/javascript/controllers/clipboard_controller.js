import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ['toolTip', 'source']

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value)
    this.displayToolTip()
  }

  displayToolTip() {
    this.toolTipTarget.classList.add(
      'tooltip',
      'tooltip-open',
      'tooltip-success'
    )
    const promise = new Promise((resolve) => setTimeout(resolve, 2000))
    promise.then(() =>
      this.toolTipTarget.classList.remove(
        'tooltip',
        'tooltip-open',
        'tooltip-success'
      )
    )
  }
}
