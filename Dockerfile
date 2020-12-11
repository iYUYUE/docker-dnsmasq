FROM alpine:edge
LABEL maintainer="dev@jpillora.com"
# webproc release settings
ENV WEBPROC_VERSION 0.3.0
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/v${WEBPROC_VERSION}/webproc_${WEBPROC_VERSION}_linux_amd64.gz
# fetch dnsmasq and webproc binary
RUN apk --no-cache add dnsmasq-dnssec curl git bash \
	# && apk add --no-cache --virtual .build-deps curl \
	&& curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
	&& chmod +x /usr/local/bin/webproc
# install dnsmasq china list
COPY ./scripts /opt/scripts
# RUN apk del .build-deps
#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf
# add cron job for dnsmasq-china-list
COPY ./scripts/update-dnsmasq-china-list.sh /etc/periodic/daily/update-dnsmasq-china-list.sh
RUN chmod +x /etc/periodic/daily/update-dnsmasq-china-list.sh
#run!
ENTRYPOINT ["/opt/scripts/start.sh"]
