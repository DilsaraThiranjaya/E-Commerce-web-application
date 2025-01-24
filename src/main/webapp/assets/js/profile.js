$(document).ready(function() {
    // Image file validation
    $('input[name="image"]').change(function(event) {
        $('#image-alert').addClass('d-none');
        $('#image-alert').removeClass('alert-success');
        $('#image-alert').removeClass('alert-danger');


        const file = event.target.files[0];
        if (!file) {
            $('#image-alert').addClass('alert-danger');
            $('#image-alert').removeClass('d-none');
            $('#image-alert').text('Please select an image file.');
            // alert('Please select an image file.');
            return;
        }

        // Check file type
        const validTypes = ['image/jpeg', "image/png"];
        if (!validTypes.includes(file.type)) {
            $('#image-alert').addClass('alert-danger');
            $('#image-alert').removeClass('d-none');
            $('#image-alert').text('Invalid file type. Only JPG, PNG are allowed.');
            // alert('Invalid file type. Only JPG, PNG, and GIF are allowed.');
            $(this).val('');  // Clear the input
            return;
        }

        // Check file size (example: limit to 2MB)
        const maxSizeInBytes = 2 * 1024 * 1024; // 2MB
        if (file.size > maxSizeInBytes) {
            $('#image-alert').addClass('alert-danger');
            $('#image-alert').removeClass('d-none');
            $('#image-alert').text('File size exceeds 2MB. Please choose a smaller file.');
            // alert('File size exceeds 2MB. Please choose a smaller file.');
            $(this).val('');  // Clear the input
            return;
        }
    });


// Add event listener to the file input to handle image selection
    document.getElementById("changePhoto").addEventListener("change", function(event) {
        var file = event.target.files[0];  // Get the selected file

        if (file) {
            // Create a FileReader to read the image file
            var reader = new FileReader();

            // Define what happens when the file is read
            reader.onload = function(e) {
                // Update the image preview source to the selected image
                document.getElementById("profileImagePreview").src = e.target.result;
            };

            // Read the file as a data URL
            reader.readAsDataURL(file);
        }
    });

    document.querySelectorAll('.toggle-password').forEach(button => {
        button.addEventListener('click', () => {
            const targetInput = document.querySelector(button.getAttribute('data-target'));
            const icon = button.querySelector('i');

            if (targetInput.type === 'password') {
                targetInput.type = 'text';
                icon.classList.remove('bi-eye');
                icon.classList.add('bi-eye-slash');
            } else {
                targetInput.type = 'password';
                icon.classList.remove('bi-eye-slash');
                icon.classList.add('bi-eye');
            }
        });
    });
});