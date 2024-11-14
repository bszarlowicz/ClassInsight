import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  triggerFileInput() {
    document.getElementById('avatarInput').click();
  }

  previewImage(event) {
    const input = event.target;
    const file = input.files[0];

    if (file) {
      const reader = new FileReader();

      reader.onload = (e) => {
        const imagePreview = document.getElementById('avatarPreview');
        imagePreview.src = e.target.result;
      };

      reader.readAsDataURL(file);
    }
  }
}

