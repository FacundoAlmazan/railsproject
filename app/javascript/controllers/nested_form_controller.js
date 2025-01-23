import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["formTemplate", "itemsList"];
  static values = {
    patternToReplaceWithIndex: String,
  };

  addItem(e) {
    e.preventDefault();

    // Genera un nuevo timestamp para reemplazar el índice
    const newIndex = new Date().getTime();

    // Obtiene el contenido del template y reemplaza el índice
    const templateContent = this.formTemplateTarget.innerHTML.replaceAll(
      this.patternToReplaceWithIndexValue,
      newIndex
    );

    // Inserta el contenido en la lista de productos
    this.itemsListTarget.insertAdjacentHTML("beforeend", templateContent);
  }
}
