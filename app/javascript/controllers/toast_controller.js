import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    const promise = new Promise((resolve) => setTimeout(resolve, 3000))
    promise.then(() => this.fadeOut(this.element))
  }

  private

  async fadeOut(element) {
    const keyframes = [
      { visibility: 'visible', opacity: '0.9' },
      { visibility: 'visible', opacity: '0.5' },
      { visibility: 'hidden', opacity: '0' }
    ]
    await element.animate(keyframes, 400)
    element.classList.add('invisible')
  }
}
