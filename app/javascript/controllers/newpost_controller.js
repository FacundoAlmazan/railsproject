import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["title", "content", "titleError", "contentError"];
  connect() {
    console.log("Controlador de formulario conectado");
    this.element.addEventListener("submit", (event) => this.validateForm(event));
  }
  
  validateForm(event) {
    let isValid = true;

    // Validar el título
    const title = this.titleTarget.value;
    if (title.length > 30) {
      this.titleErrorTarget.textContent = "El título no puede tener más de 30 caracteres.";
      this.titleErrorTarget.classList.remove("hidden");
      isValid = false;
    } else if (title.toLowerCase().includes("nigga") || title.toLowerCase().includes("nigger")) {
      this.titleErrorTarget.textContent = "El título contiene palabras prohibidas.";
      this.titleErrorTarget.classList.remove("hidden");
      isValid = false;
    } else {
      this.titleErrorTarget.classList.add("hidden");
    }

    // Validar el contenido
    const content = this.contentTarget.value;
    if (content.length > 140) {
      this.contentErrorTarget.textContent = "El contenido no puede tener más de 140 caracteres.";
      this.contentErrorTarget.classList.remove("hidden");
      isValid = false;
    } else if (content.toLowerCase().includes("nigga") || content.toLowerCase().includes("nigger")) {
      this.contentErrorTarget.textContent = "El contenido contiene palabras prohibidas.";
      this.contentErrorTarget.classList.remove("hidden");
      isValid = false;
    } else {
      this.contentErrorTarget.classList.add("hidden");
    }

    if (!isValid) {
      event.preventDefault(); // Evitar que el formulario se envíe
    }
  }
}