# Local AWS emulation with Terraform
Mock AWS services with LocalStack on Docker and configure through Terraform.

https://qiita.com/takapg/items/5c1ee7f8645effb9e37b


## Script
Before run following scripts, make sure to run docker!
### Load localstack
```bash
$ cd localstack
$ docker-compose -f . up -d 
```

### Setup terraform local
```bash
$ cd tflocal
$ docker build -t tflocal:0.2 .
...
Successfully tagged tflocal:0.2
$ docker run --rm -it -v $(pwd):/app --net=localstack_default tflocal:0.2 <any commands for tflocal>
```

### For invoking lambda function on LocalStack
- Docker network cannot be accessed from outside of docker network! You need to run aws/cli on docker too.
- Make sure to output log file to /app directory!
```bash
$ docker run --rm -it -v "$(pwd)":/app --net=localstack_default --env AWS_ACCESS_KEY_ID=dummy --env AWS_SECRET_ACCESS_KEY=dummy --env AWS_DEFAULT_REGION=ap-northeast-1 amazon/aws-cli:2.6.1 --endpoint-url http://localstack:4566 lambda invoke --function-name func_sample --payload $(echo '{ "name" : "Bob" }' | base64) /app/result.log
```