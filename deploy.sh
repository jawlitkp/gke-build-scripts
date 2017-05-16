#!/bin/sh

set -e

echo $GOOGLE_AUTH_JSON > ./keyconfig.json

# Activate service account in gcloud
gcloud auth activate-service-account --key-file ./keyconfig.json --project $GOOGLE_PROJECT_ID $GOOGLE_AUTH_EMAIL

# Disable usage reporting which causes errors on codeship
gcloud config set disable_usage_reporting true
gcloud config set disable_prompts true
gcloud config set compute/zone $COMPUTE_ZONE

echo "Update gcloud components"
gcloud components update gcloud

echo "Fetch credentials of running cluster and update kubeconfig file"
gcloud beta container clusters get-credentials ${CLUSTER_NAME}

# Set default application credentials for kubectl so we can call Google APIs
export GOOGLE_APPLICATION_CREDENTIALS="/keyconfig.json"

echo "Update deployment with new image"
kubectl set image deployment/${DEPLOYMENT_NAME} ${DEPLOYMENT_NAME}=${GCR_NAME}:$CI_COMMIT_ID

echo "Watch rollout status until it's done"
kubectl rollout status deployment/${DEPLOYMENT_NAME}
