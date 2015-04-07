FROM ubuntu:14.04

MAINTAINER Manel Martinez <manel@nixelsolutions.com>

RUN apt-get update && \
    apt-get install -y openvpn iptables sshpass supervisor ipcalc

RUN mkdir -p /etc/openvpn /var/log/supervisor

ENV VPN_PATH /etc/openvpn
ENV VPN_SERVERS **ChangeMe**
ENV VPN_PASSWORD **ChangeMe**
ENV DEBUG 0

WORKDIR /etc/openvpn

RUN mkdir -p /usr/local/bin
ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

ADD ./etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/local/bin/run.sh"]
