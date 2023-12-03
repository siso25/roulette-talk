import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  copy() {
    navigator.clipboard.writeText(location.href)
  }
}
