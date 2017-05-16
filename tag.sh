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

echo "Add tag ${GCR_NAME}:latest to ${GCR_NAME}:${CI_COMMIT_ID}"
gcloud beta container images add-tag ${GCR_NAME}:$CI_COMMIT_ID ${GCR_NAME}:latest

echo "Add tag ${GCR_NAME}:${CI_BRANCH} to ${GCR_NAME}:${CI_COMMIT_ID}"
gcloud beta container images add-tag ${GCR_NAME}:$CI_COMMIT_ID ${GCR_NAME}:$CI_BRANCH
