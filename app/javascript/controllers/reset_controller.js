import { Controller } from "@hotwired/stimulus"
import { createLotteryTargets } from "../helpers/local_storage"

// Connects to data-controller="reset"
export default class extends Controller {
  execute() {
    createLotteryTargets('talk', '1, 2, 3, 4')
    createLotteryTargets('speaker', '1, 2, 3, 4')
  }
}
