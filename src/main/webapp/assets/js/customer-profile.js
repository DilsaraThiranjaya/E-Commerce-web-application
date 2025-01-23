$(document).ready(function() {

// Add event listener to the file input to handle image selection
    document.getElementById("fileInput").addEventListener("change", function(event) {
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
});