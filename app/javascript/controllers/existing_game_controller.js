import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message", "id"]

  submit(event) {
    event.preventDefault()

    const gameId = this.idTarget.value

    fetch(`/games/${gameId}`)
      .then((response) => {
        if (response.ok) {
          Turbo.visit(`/games/${gameId}`)
        } else {
          this.messageTarget.hidden = false
        }
      })
  }
}
