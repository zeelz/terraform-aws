#!/bin/sh

apk add --no-cache openssh-client 

echo "ZEELZ_EC2_IP: $ZEELZ_EC2_IP"

echo "ssh-keyscan"
ssh-keyscan -H "$ZEELZ_EC2_IP" >> /tmp/known_hosts

chmod 400 "$SSH_PRIVATE_KEY"

# ssh -o StrictHostKeyChecking=no -i "$SSH_PRIVATE_KEY" "$AWS_USER"@"$ZEELZ_EC2_IP" "echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USER" --password-stdin &&
# docker pull $DOCKER_USER/express-gitlab &&
# docker ps -aq | xargs docker rm -f || true &&
# docker run -d -p 5500:5500 -e PORT=5500 -e DB_USER=zeelz -e DB_HOST=5.tcp.eu.ngrok.io -e DB_NAME=postgres -e DB_PORT=11010 zeelz/express-gitlab"