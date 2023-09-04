# #!/bin/sh

# ENV=$1
# echo "Deploying webservice to $ENV"

# NAME=airflowlocaltest-$ENV
# ACR_NAME=airflowlocaltest$ENV
# echo "Deploying webservice to Azure for $NAME"
# REGION=us-east
# ECR_URL="$ACR_NAME.azurecr.io"

# COMMIT_HASH=`date +%Y%m%d%H%M%S`
# echo "COMMIT_HASH: $COMMIT_HASH"

# echo "Building image: $NAME:latest"
# docker build --rm -t $NAME:latest .

# az acr login --name $ACR_NAME

# #tag and push image using latest
# docker tag $NAME $ECR_URL/$NAME:latest  
# docker push $ECR_URL/$NAME:latest

# #deploy to aks cluster
# az aks get-credentials --resource-group Test --name airflowlocaltest

# # Add debugging information
# echo "Current context:"
# kubectl config current-context

# echo "View cluster information:"
# kubectl cluster-info

# kubectl set image deployment/airflow-webserver airflow-webserver=$ECR_URL/$NAME:latest
# kubectl set image deployment/airflow-scheduler airflow-scheduler=$ECR_URL/$NAME:latest
# kubectl set image deployment/airflow-worker airflow-worker=$ECR_URL/$NAME:latest
# kubectl set image deployment/airflow-flower airflow-flower=$ECR_URL/$NAME:latest

# kubectl rollout status deployment airflow-webserver
# kubectl rollout status deployment airflow-scheduler
# kubectl rollout status deployment airflow-worker
# kubectl rollout status deployment airflow-flower







#!/bin/sh

ENV=$1
echo "Deploying webservice to $ENV"

NAME=airflowlocaltest-$ENV
ACR_NAME=airflowlocaltest$ENV
echo "Deploying webservice to Azure for $NAME"
REGION=us-east
ECR_URL="$ACR_NAME.azurecr.io"

# Build the Docker image
docker build --rm -t $NAME:latest .

az acr login --name $ACR_NAME

# Get the image digest (SHA ID)
SHA_ID=$(docker image inspect --format='{{index .RepoDigests 0}}' $NAME:latest)
echo "$SHA_ID"

# Tag the image with the SHA ID as the tag
#docker tag $NAME:latest $ECR_URL/$NAME:$SHA_ID

# Push the image to ACR
#docker push $ECR_URL/$NAME:$SHA_ID

# Deploy to AKS cluster
#az aks get-credentials --resource-group Test --name airflowlocaltest

# Add debugging information
#echo "Current context:"
#kubectl config current-context

#echo "View cluster information:"
#kubectl cluster-info

# Update the AKS deployment to use the newly tagged image
#kubectl set image deployment/airflow-webserver airflow-webserver=$ECR_URL/$NAME:$SHA_ID
#kubectl set image deployment/airflow-scheduler airflow-scheduler=$ECR_URL/$NAME:$SHA_ID
#kubectl set image deployment/airflow-worker airflow-worker=$ECR_URL/$NAME:$SHA_ID
#kubectl set image deployment/airflow-flower airflow-flower=$ECR_URL/$NAME:$SHA_ID

# Monitor the deployment status
#kubectl rollout status deployment airflow-webserver
#kubectl rollout status deployment airflow-scheduler
#kubectl rollout status deployment airflow-worker
#kubectl rollout status deployment airflow-flower
