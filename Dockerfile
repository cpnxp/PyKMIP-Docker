FROM ubuntu:20.04
SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade --assume-yes && apt install -y openssl python3 python3-distutils python3-pip python3-apt wget

RUN mkdir /var/log/pykmip && mkdir /etc/pykmip && mkdir /etc/pykmip/policy

RUN python3 -m pip install pykmip

#Override this ENV Var if you want to change the subject of your cert
#Cert is created on first run of the container by detecting if the PyKMIP DB exists
#Uses openssl subj format, see openssl docs for more info (openssl req -x509)
ENV CERT_SUBJ="/C=XX/ST=Your_State/L=Your_City/O=Your_Org/OU=Your_Unit/CN=Your_Hostname"
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /etc/pykmip
EXPOSE 5696/tcp
ENTRYPOINT ["docker-entrypoint.sh","pykmip-server"]

