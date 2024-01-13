document.addEventListener('DOMContentLoaded', () => {
    const inputField = document.querySelector('#user_photo');

    inputField.addEventListener('change', (event) => {
        const file = event.target.files[0];
        const preview = document.querySelector('#imagePreview');

        const reader = new FileReader();
        reader.onload = () => {
        preview.src = reader.result;
        preview.style.display = 'block';
        };

        if (file) {
        reader.readAsDataURL(file);
        }
    });
});
  