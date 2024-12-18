import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["alert"]
  
    connect() {
      console.log("holiwis");
      setTimeout(() => {
        this.fadeOutAlert();
      }, 2000); 
    }
  
    fadeOutAlert() {
        this.element.style.transition = "opacity 0.5s ease";
        this.element.style.opacity = "0";
        setTimeout(() => this.alertTarget.remove(), 500);
      }
  }
  

