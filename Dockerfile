FROM alpine:edge
LABEL maintainer="dev@jpillora.com"
# webproc release settings
ENV WEBPROC_VERSION 0.3.0
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/v${WEBPROC_VERSION}/webproc_${WEBPROC_VERSION}_linux_amd64.gz
# fetch dnsmasq and webproc binary
RUN apk update \
	&& apk --no-cache add dnsmasq-dnssec \
	&& apk add --no-cache --virtual .build-deps curl git bash \
	&& curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
	&& chmod +x /usr/local/bin/webproc
# install dnsmasq china list
COPY ./install-dnsmasq-china-list.sh /opt/install.sh
RUN /opt/install.sh \
	&& rm -f /opt/install.sh \
	&& apk del .build-deps
#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf
#run!
ENTRYPOINT ["webproc","-c","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]
