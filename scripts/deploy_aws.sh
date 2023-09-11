NAME=$1
AWS_ACCOUNT=${2:-791167451670}
REGION=us-east-1
ECR_URL="$AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com"
CLUSTER="arn:aws:ecs:$REGION:$AWS_ACCOUNT:cluster/$NAME"

COMMIT_HASH=`date +%Y%m%d%H%M%S`
echo $COMMIT_HASH



echo "Building image: $NAME:latest"
docker build --rm -t $NAME:latest .

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL

# tag and push image using latest
docker tag $NAME $ECR_URL/$NAME:latest
docker push $ECR_URL/$NAME:latest
