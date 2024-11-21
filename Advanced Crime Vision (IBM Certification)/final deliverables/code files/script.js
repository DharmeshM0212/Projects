function predictCrime() {
    const fileInput = document.getElementById("image-upload");
    const predictionResult = document.getElementById("prediction-result");
    predictionResult.innerHTML = "Predicting...";
    predictionResult.classList.remove("hidden");
    
    const file = fileInput.files[0];
    
    const formData = new FormData();
    formData.append("image", file);

    
    fetch("/predict", {
      method: "POST",
      body: formData
    })
    .then(response => response.json())
    .then(result => {
      predictionResult.innerHTML = "Prediction: " + result.prediction;
    })
    .catch(error => {
      predictionResult.innerHTML = "Error occurred during prediction.";
      console.error(error);
    });
  }