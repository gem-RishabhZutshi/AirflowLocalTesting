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

echo "Building image: $NAME:latest"
docker build --rm -t $NAME:latest .

az acr login --name $ACR_NAME

# tag and push image using latest
docker tag $NAME $ECR_URL/$NAME:latest
docker push $ECR_URL/$NAME:latest

# deploy to aks cluster
az aks get-credentials --resource-group Test --name airflowlocaltest
kubectl set image deployment/airflow-webserver airflow-webserver=$ECR_URL/$NAME:latest
