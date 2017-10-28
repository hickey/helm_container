FROM nginx:1-alpine-perl
MAINTAINER Gerard Hickey "<hickey@kinetic-compute.com>"

ENV HELM_VERSION "2.7.0"

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl && \
    cd /tmp && \
    wget https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    cd / && rm -rf /tmp/* && mkdir -p /usr/share/nginx/cgi-bin

ADD nginx-helm.conf /etc/nginx/conf.d/
ADD mime.types /etc/nginx/
ADD upload /usr/share/nginx/cgi-bin/
