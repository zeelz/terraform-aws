#!/bin/sh

apk add --no-cache openssh-client

echo "ssh-keyscan to known_hosts"
ssh-keyscan -H "$ZEELZ_EC2_IP" >> /tmp/known_hosts

chmod 400 "$SSH_PRIVATE_KEY" # stored as file

ssh -o StrictHostKeyChecking=no -i "$SSH_PRIVATE_KEY" "$AWS_USER@$ZEELZ_EC2_IP" "echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USER" --password-stdin &&
docker pull $DOCKER_USER/express-gitlab &&
docker ps -aq | xargs docker rm -f || true &&
docker run -d -p 5500:5500 -e PORT=5500 -e DB_USER="$DB_USER" -e DB_PASSWORD="$DB_PASSWORD" -e DB_HOST="$DB_HOST" -e DB_NAME="$DB_NAME" -e DB_PORT="$DB_PORT" zeelz/express-gitlab"