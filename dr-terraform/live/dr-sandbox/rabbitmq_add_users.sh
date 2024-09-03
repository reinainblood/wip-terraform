#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install it and try again."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it and try again."
    exit 1
fi

# Read environment variables from terraform.tfvars
broker_name=$(grep 'broker_name' terraform.tfvars | awk -F'"' '{print $2}')

# Get broker ID
broker_id=$(aws mq list-brokers --query "BrokerSummaries[?BrokerName=='$broker_name'].BrokerId" --output text --profile=sandbox)

if [ -z "$broker_id" ]; then
    echo "Broker not found. Please check the broker name and your AWS CLI configuration."
    exit 1
fi

# Read users from JSON file
users=$(jq -c '.users[]' rabbitmq_users.json)

# Loop through users and add them to the broker
for user in $users; do
    username=$(echo $user | jq -r '.username')
    groups=$(echo $user | jq -r '.groups | join(",")')

    # Get password from AWS Secrets Manager
    secret_name="assetreality-rabbitmq-${username}-password"
    password=$(aws secretsmanager get-secret-value --secret-id "$secret_name" --query 'SecretString' --output text --profile=sandbox)

    if [ -z "$password" ]; then
        echo "Password not found for user $username. Skipping..."
        continue
    fi

    # Create or update user
    aws mq create-user --broker-id "$broker_id" --username "$username" --password "$password" --groups "$groups" --profile=sandbox

    if [ $? -eq 0 ]; then
        echo "User $username added/updated successfully."
    else
        echo "Failed to add/update user $username."
    fi
done

echo "User addition process completed."