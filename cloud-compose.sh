#!/bin/sh -e

if [ -f "/var/lib/cloud-compose/docker-compose.yml" ]; then

    cd /var/lib/cloud-compose

    # instance and region
    instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)

    # env
    rm -f .env
    tags_json=$(aws ec2 describe-tags --region $region --filters "Name=resource-id,Values=$instance_id")
    for key in $(echo $tags_json | jq -r ".[][].Key"); do
        value=$(echo $tags_json | jq -r ".[][] | select(.Key==\"$key\") | .Value")
        key=$(echo $key | tr '-' '_' | tr ':' '_' | tr '.' '_')
        echo "$key=$value" | tee -a .env
    done

    # docker login
    docker_username=$(aws ssm get-parameters --region $region --names docker.username | jq .Parameters[0].Value -r)
    if [ "$docker_username" != "" ]; then
        docker_password=$(aws ssm get-parameters --region $region --names docker.password | jq .Parameters[0].Value -r)
        docker login -u $docker_username -p $docker_password
    fi

    # docker compose
    docker-compose up -d

fi