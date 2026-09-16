## Express Containerized
Express Containerized is a simple sample express app with postgres database integration.

[https://hub.docker.com/r/zeelz/express-containerized](https://hub.docker.com/r/zeelz/express-containerized)


### Environment variables

PORT (optional)
DB_USER
DB_HOST
DB_NAME
DB_PASSWORD (optional)
DB_PORT

### Example Run

```docker run -d -p 3000:3000 \
--platform linux/amd64 \
-e "DB_USER=zeelz" \
-e "DB_HOST=4.tcp.eu.ngrok.io" \
-e "DB_NAME=postgres" \
-e "DB_PORT=27784" zeelz/express-containerized:TAG
```


###Available routes

GET /

GET /users

POST /users {name, email}


## Overview of Terraform, Ansible

This repository contains Terraform Iac script to provision EC2 on AWS using GitHub Action and GitLab CI

It is connected to two remotes:
github  zeelz:zeelz/terraform-aws.git
origin  gitlab:Zeelz/express-containerized.git

Working branch: dev

git commit -am "Update ..." -m "..." && git push -uf origin dev
git commit -am "Update ..." -m "..." && git push github dev