FROM golang:alpine as credsBuilder

ARG CREDS_HELPER=v0.4.0

RUN apk --no-cache add git && \
    git clone --branch=$CREDS_HELPER https://github.com/awslabs/amazon-ecr-credential-helper /go/src/github.com/awslabs/amazon-ecr-credential-helper && \
    go build -o /assets/docker-credential-ecr-login github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

FROM docker:19.03
ADD config.json /root/.docker/config.json
COPY --from=credsBuilder /assets/docker-credential-ecr-login /usr/local/bin/docker-credential-ecr-login