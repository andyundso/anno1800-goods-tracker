import {Controller} from "@hotwired/stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["username", "gameId"]

  create(event) {
    event.preventDefault()

    if (this.usernameTarget.reportValidity()) {
      const username = this.usernameTarget.value

      Rails.ajax({
        url: "/games", type: "POST", data: `username=${username}`, success: (data) => {
          Turbo.visit(`/games/${data.id}`)
        }
      });
    }
  }

  open(event) {
    event.preventDefault()

    if (this.usernameTarget.reportValidity() && this.gameIdTarget.reportValidity()) {
      const gameId = this.gameIdTarget.value
      const username = this.usernameTarget.value

      window.location.href = `/games/${gameId}?username=${username}`;
    }
  }
}
