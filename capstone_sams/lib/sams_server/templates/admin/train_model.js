$(document).ready(function () {
    // Handle button click
    $("#retrain-button").on("click", function () {
        // Send an AJAX POST request to trigger retraining
        $.ajax({
            type: "POST",
            url: "/admin/api/healthsymptom/retrain_model/",
            data: $("retrain_model/").serialize(),
            success: function (data) {
                // Handle the response here (e.g., show a success message)
                if (data.success) {
                    alert("Model retraining completed successfully: " + data.message);
                } else {
                    alert("Model retraining failed: " + data.message);
                }
            },
            error: function () {
                alert("An error occurred while retraining the model.");
            }
        });
    });
});
