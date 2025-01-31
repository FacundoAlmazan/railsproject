import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["username", "usernameFeedback", "email", "emailFeedback", "phone", "phoneFeedback", "password", "passFeedback", "passwordConfirmation", "repassFeedback", "submit"]

    validateForm(event) {
        let hasError = false;

        if (!this.checkUsername()) hasError = true;
        if (!this.checkEmail()) hasError = true;
        if (!this.validatePhone()) hasError = true;
        if (!this.validatePassword()) hasError = true;
        if (!this.validatePasswordConfirmation()) hasError = true;

        if (hasError) {
        event.preventDefault(); 
        alert("Por favor, corrige los errores antes de enviar el formulario.");
        }
    }

    checkUsername() {
        let username = this.usernameTarget.value.trim();
        this.usernameFeedbackTarget.textContent = "";
        if (username.length < 6) {
            this.usernameFeedbackTarget.textContent = "Debe tener al menos 6 caracteres.";
            this.usernameFeedbackTarget.style.color = "red";
            return false;
        }
        return true;
    }

    checkEmail() {
        let email = this.emailTarget.value.trim();
        this.emailFeedbackTarget.textContent = "";
        if (!this.validateEmail(email)) {
            this.emailFeedbackTarget.textContent = "Formato inválido";
            this.emailFeedbackTarget.style.color = "red";
            return false;
        }
        return true;
    }

    validatePhone() {
        let phone = this.phoneTarget.value.trim();
        this.phoneFeedbackTarget.textContent = "";
        if (!/^\d{8,15}$/.test(phone)) {
            this.phoneFeedbackTarget.textContent = ("Debe tener entre 8 y 15 dígitos.");
            this.phoneFeedbackTarget.style.color = "red";
            return false;
        }
        return true;
    }

    validatePassword() {
        let password = this.passwordTarget.value;
        this.passFeedbackTarget.textContent = "";
        if (password.length > 0 && password.length < 6) {
            this.passFeedbackTarget.textContent = ("Debe tener al menos 6 caracteres.");
            this.passFeedbackTarget.style.color = "red";
            return false;
        }
        return true;
    }

    validatePasswordConfirmation() {
        let password = this.passwordTarget.value;
        let confirmation = this.passwordConfirmationTarget.value;
        this.repassFeedbackTarget.textContent = "";
        if (password !== confirmation) {
            this.repassFeedbackTarget.textContent = ("Las contraseñas no coinciden.");
            this.repassFeedbackTarget.style.color = "red";
            return false;
        }
        return true;
    }


    validateEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

}
