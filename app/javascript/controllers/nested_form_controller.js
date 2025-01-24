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

  removeItem(e) {
    e.preventDefault();

    // Encuentra el contenedor del elemento que se va a eliminar
    const item = e.target.closest(".nested-fields");

    // Si es un nested form existente, marca el campo _destroy para eliminarlo
    const destroyField = item.querySelector('input[name*="_destroy"]');
    if (destroyField) {
      destroyField.value = "1";
      item.style.display = "none"; // Oculta el elemento
    } else {
      // Si es un nuevo elemento, simplemente remuévelo del DOM
      item.remove();
    }
  }
  
}
