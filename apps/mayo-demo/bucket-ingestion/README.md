# Cluster Requirements:

Enable access to all apis

# Platform Requirements:

## Create project

## Create GSA

SA Name: workload-id-gsa@mg-test-project-374923.iam.gserviceaccount.com

## Set GCP IAM bindings on GSA at project level:

BigQuery Admin
Pub/Sub Admin
Storage Admin

## Setup pubsub topic:

pubsub topic name projects/mg-test-project-374923/topics/bq_load

## Create source bucket:

bucket name - default-us-bucket-compositon-test

## Setup bucket pubsub event:

gcloud storage buckets notifications create gs://default-us-bucket-compositon-test #topic=projects/mg-test-project-374923/topics/bq_load

## Create bq dataset:

ccp_demo_username_ds

# Setup Argo Events:

## Deploy Argo Events:

kubectl create namespace argo-events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml

## Deploy eventbus:

kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml

## Create ksa and set proper bindings:

k apply -f event-ksa.yaml

## Set up workload identity :

gcloud iam service-accounts add-iam-policy-binding workload-id-gsa@mg-test-project-374923.iam.gserviceaccount.com \
 #role roles/iam.workloadIdentityUser \
 #member "serviceAccount:mg-test-project-374923.svc.id.goog[argo-events/events-workload-id-ksa]"

kubectl annotate serviceaccount events-workload-id-ksa \
 #namespace argo-events \
 iam.gke.io/gcp-service-account=workload-id-gsa@mg-test-project-374923.iam.gserviceaccount.com

## Deploy eventsource:

update serviceAccountName to match
update projectID
update topic
k apply -f event-source.yaml

## create configmap

k create configmap wrapper #from-file=wrapper.sh
\*ensure dataset name and source file is correct

## Deploy eventsensor

update serviceAccountName
update eventSourceName *match metadata.name in eventsource
update eventName *match spec.pubSub.pubsub-event
k apply event-sensor-simple.yaml

## test

Manual - gcloud pubsub topics publish projects/mg-test-project-374923/topics/bq_load #message='{"message": "testing with gcloud"}'
Bucket trigger - upload username.csv into bucket to trigger pubsub event
k get pods
A new pod should be created
