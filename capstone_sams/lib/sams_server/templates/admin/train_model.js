$(document).ready(function () {
    $("#retrain-button").on("click", function () {
        $.ajax({
            type: "POST",
            url: "/admin/api/healthsymptom/retrain_model/",
            data: $("retrain_model/").serialize(),
            success: function (data) {
                if (data.success) {
                    alert("Model retraining: " + data.message);
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
