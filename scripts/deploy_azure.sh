#!/bin/sh

ENV=$1
echo "Deploying webservice to $ENV"

NAME=airflowlocaltest-$ENV
ACR_NAME=airflowlocaltest$ENV
echo "Deploying webservice to Azure for $NAME"
REGION=us-east
ECR_URL="$ACR_NAME.azurecr.io"

COMMIT_HASH=`date +%Y%m%d%H%M%S`
echo "COMMIT_HASH: $COMMIT_HASH"

echo "Building image: $NAME:V2"
docker build --rm -t $NAME:V2 .

az acr login --name $ACR_NAME

tag and push image using latest
docker tag $NAME $ECR_URL/$NAME:V2
docker push $ECR_URL/$NAME:V2

#deploy to aks cluster
az aks get-credentials --resource-group Test --name airflowlocaltest

# Add debugging information
echo "Current context:"
kubectl config current-context

echo "View cluster information:"
kubectl cluster-info

kubectl set image deployment/airflow-webserver airflow-webserver=$ECR_URL/$NAME:V2
kubectl set image deployment/airflow-scheduler airflow-scheduler=$ECR_URL/$NAME:V2
kubectl set image deployment/airflow-worker airflow-worker=$ECR_URL/$NAME:V2
kubectl set image deployment/airflow-flower airflow-flower=$ECR_URL/$NAME:V2

kubectl rollout status deployment airflow-webserver
kubectl rollout status deployment airflow-scheduler
kubectl rollout status deployment airflow-worker
kubectl rollout status deployment airflow-flower
