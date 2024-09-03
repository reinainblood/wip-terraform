#!/bin/bash

SERVICE_NAME=$1
REGION=$2
ACCOUNT_ID=$3
REPOSITORY_NAME=$4

LATEST_TAG=$(aws ecr describe-images --repository-name $REPOSITORY_NAME --region $REGION --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text)

echo "{\"image_tag\": \"$LATEST_TAG\"}"