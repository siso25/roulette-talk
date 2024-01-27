import { Controller } from '@hotwired/stimulus'
import { findByKey } from '../helpers/storage'

export default class extends Controller {
  static values = { key: String }
  static targets = ['item']

  changeBackgroundColor() {
    if (findByKey(this.keyValue).length === 0) {
      this.resetBackgroundColor()
      return
    }

    const index = findByKey(`${this.keyValue}ResultIndex`)
    this.itemTargets[index].classList.add('bg-base-300')
  }

  resetBackgroundColor() {
    console.log('reset')
    this.itemTargets.forEach((element) =>
      element.classList.remove('bg-base-300')
    )
  }
}
