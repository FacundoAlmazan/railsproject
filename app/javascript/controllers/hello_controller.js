import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("holi");
    this.element.textContent = "¡Hola desde Stimulus!";
  }
}
