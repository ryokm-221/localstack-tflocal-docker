FROM python:3.8.13-slim

RUN apt-get update -y && \
  apt-get install -y gnupg software-properties-common curl unzip && \
  curl -OL https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_arm64.zip && \
  unzip terraform_1.2.6_linux_arm64.zip && \
  chmod +x terraform && \
  mv terraform /usr/bin

RUN which terraform && \
  pip install terraform-local==0.2

WORKDIR /app

ENV LOCALSTACK_HOSTNAME=localstack \
  S3_HOSTNAME=localstack \
  TF_VAR_s3_use_path_style=true \
  AWS_DEFAULT_REGION=ap-northeast-1

ENTRYPOINT [ "tflocal" ]