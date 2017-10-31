FROM nimmis/alpine-nginx:latest
MAINTAINER Gerard Hickey "<hickey@kinetic-compute.com>"

ENV HELM_VERSION "2.7.0"

RUN apk update && \

    # Install necessary packages
    apk add ca-certificates openssl python uwsgi-python nginx-mod-http-echo && \

    # Update the CA roots
    update-ca-certificates && \

    # Retrieve and install Helm
    cd /tmp && \
    wget https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    cd / && rm -rf /tmp/* && \

    # Make the directory for the upload script
    mkdir /web/cgi-bin

ADD nginx.conf /etc/nginx/
ADD mime.types /etc/nginx/
ADD uwsgi.ini /etc/uwsgi/
ADD uwsgi-run /etc/service/uwsgi/run
ADD upload.py /web/cgi-bin/
ADD html/ /web/html/
