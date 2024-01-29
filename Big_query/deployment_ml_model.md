# TensorFlow Model Deployment with BigQuery ML and TensorFlow Serving

This guide outlines the steps to deploy a TensorFlow model trained on BigQuery ML using TensorFlow Serving. The example here is focused on a taxi tip prediction model.

## Prerequisites

- **Google Cloud SDK:** Ensure you have the Google Cloud SDK installed and authenticated.
  ```bash
  gcloud auth login
  ```

## Step 1: Export BigQuery ML Model

```bash
bq --project_id taxi-rides-ny extract -m nytaxi.tip_model gs://taxi_ml_model/tip_model
```

This command exports the BigQuery ML model to Cloud Storage.

## Step 2: Copy Model to Local Directory

```bash
mkdir /tmp/model
gsutil cp -r gs://taxi_ml_model/tip_model /tmp/model
```

Copy the exported model from Cloud Storage to a local directory.

## Step 3: Prepare TensorFlow Serving Directory

```bash
mkdir -p serving_dir/tip_model/1
cp -r /tmp/model/tip_model/* serving_dir/tip_model/1
```

Organize the model files in a directory structure compatible with TensorFlow Serving.

## Step 4: Pull TensorFlow Serving Docker Image

```bash
docker pull tensorflow/serving
```

Pull the TensorFlow Serving Docker image from the official repository.

## Step 5: Run TensorFlow Serving Container

```bash
docker run -p 8501:8501 --mount type=bind,source=$(pwd)/serving_dir/tip_model,target=/models/tip_model -e MODEL_NAME=tip_model -t tensorflow/serving &
```

Run TensorFlow Serving as a Docker container, exposing port 8501 and mounting the model directory.

## Step 6: Test Model Inference

```bash
curl -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' -X POST http://localhost:8501/v1/models/tip_model:predict
```

Submit a test request to the TensorFlow Serving container to ensure the model is running and making predictions.

## Step 7: Check Model Status

```bash
http://localhost:8501/v1/models/tip_model
```
