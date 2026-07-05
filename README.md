## Simple Express API image

[https://hub.docker.com/r/zeelz/simple-express-app](https://hub.docker.com/r/zeelz/simple-express-app)

```
docker run -d
-p [HOST_PORT]:[CONTAINER_PORT] \
-e PORT=[CONTAINER_PORT] \
--platform linux/amd64 \
zeelz/simple-express-app
```

Change `HOST_PORT` and `CONTAINER_PORT` to your desired ports

**Example**

`docker run -d -p 3000:3000 -e "PORT=3000" --platform linux/amd64 zeelz/simple-express-app`

**Available route**

GET `/users`

POST `/users` {name, email}


-

This repository contains Terraform Iac script to provision EC2 on AWS using GitHub Action and GitLab CI

It is connected to two remotes:
github  zeelz:zeelz/terraform-aws.git
origin  gitlab:Zeelz/express-containerized.git

Working branch: dev

git commit -am "Update ..." -m "..." && git push -uf origin dev
git commit -am "Update ..." -m "..." && git push github dev