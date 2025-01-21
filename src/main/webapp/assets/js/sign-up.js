$(document).ready(function() {
    // Image file validation
    $('input[name="image"]').change(function(event) {
        const file = event.target.files[0];
        if (!file) {
            alert('Please select an image file.');
            return;
        }

        // Check file type
        const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
        if (!validTypes.includes(file.type)) {
            alert('Invalid file type. Only JPG, PNG, and GIF are allowed.');
            $(this).val('');  // Clear the input
            return;
        }

        // Check file size (example: limit to 2MB)
        const maxSizeInBytes = 2 * 1024 * 1024; // 2MB
        if (file.size > maxSizeInBytes) {
            alert('File size exceeds 2MB. Please choose a smaller file.');
            $(this).val('');  // Clear the input
            return;
        }

        alert('File is valid!');
    });
});