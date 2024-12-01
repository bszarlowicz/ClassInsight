import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  static targets = ["container", "input_form"];
  connect() {
    this.resetScroll();
    this.setupMutationObserver();
  }

  setupMutationObserver() {
    const observer = new MutationObserver((mutationsList) => {
      mutationsList.forEach((mutation) => {
        if (mutation.type === 'childList') {
          this.resetScroll();
        }
      });
    });

    const config = { childList: true };
    observer.observe(this.containerTarget, config);
  }

  resetScroll(){
    const scrollHeight = this.containerTarget.scrollHeight;
    this.containerTarget.scrollTo(0, scrollHeight);
    this.checkCurrentUser();
  }

  resetForm(){
    this.input_formTarget.reset();
  }

  checkCurrentUser(){
    const current_user_id = document.getElementById('messages').getAttribute('data-current-user-id');
    this.containerTarget.querySelectorAll('.message').forEach(message => {
      const messageUserId = message.getAttribute('data-user-id');
      if (messageUserId === current_user_id) {
        message.classList.add('message-item-right');
        message.classList.remove('message-item-left');
      } else {
        message.classList.add('message-item-left');
        message.classList.remove('message-item-right');
      }
    });
  }
}
