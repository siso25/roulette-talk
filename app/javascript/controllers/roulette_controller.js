import { Controller } from "@hotwired/stimulus"
import { saveTargets } from "../helpers/storage"

export default class extends Controller {
  connect() {
    saveTargets('talk', '1, 2, 3, 4')
    saveTargets('speaker', '1, 2, 3, 4')
  }

  reset() {
    saveTargets('talk', '1, 2, 3, 4')
    saveTargets('speaker', '1, 2, 3, 4')
  }
}
