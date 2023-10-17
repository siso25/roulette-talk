import { Controller } from "@hotwired/stimulus"
import { createLotteryTargets } from "../helpers/local_storage"

// Connects to data-controller="roulette"
export default class extends Controller {
  connect() {
    createLotteryTargets('talk', '1, 2, 3, 4')
    createLotteryTargets('speaker', '1, 2, 3, 4')
  }
}
