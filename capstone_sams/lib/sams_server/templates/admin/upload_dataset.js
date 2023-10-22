$(document).ready(function () {
    $(".upload-button").on("click", function () {
        $.ajax({
            type: "POST",
            url: "/admin/api/healthsymptom/upload_dataset/",
            data: $("upload_dataset/").serialize(),
            success: function (data) {
                if (data.success) {
                    alert("Dataset upload: " + data.message);
                } else {
                    alert("Dataset upload failed: " + data.message);
                }
            },
            error: function () {
                alert("An error occurred while uploading the dataset.");
            }
        });
    });
});
