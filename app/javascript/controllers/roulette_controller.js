import { Controller } from "@hotwired/stimulus"
import { createLotteryTargets } from "../helpers/local_storage"

export default class extends Controller {
  connect() {
    createLotteryTargets('talk', '1, 2, 3, 4')
    createLotteryTargets('speaker', '1, 2, 3, 4')
  }

  reset() {
    createLotteryTargets('talk', '1, 2, 3, 4')
    createLotteryTargets('speaker', '1, 2, 3, 4')
  }
}
