FROM mastermindg/rpi-haproxy:1.6-alpine

RUN apk --update add curl unzip
RUN apk add --virtual .build-deps
RUN curl -SL https://releases.hashicorp.com/consul-template/0.13.0/consul-template_0.13.0_linux_arm.zip -o /usr/local/bin/consul-template.zip && \
    unzip /usr/local/bin/consul-template.zip -d /usr/local/bin/ && \
    rm -f /usr/local/bin/consul-template.zip && \
    chmod +x /usr/local/bin/consul-template && \
    apk del .build-deps

RUN mkdir -p /cfg/tmpl
RUN mkdir /consul_templates

ENV CONSUL_ADDRESS ""
ENV PROXY_INSTANCE_NAME "docker-flow"
ENV MODE "default"
ENV SERVICE_NAME "proxy"

EXPOSE 80
EXPOSE 443
EXPOSE 8080

CMD ["docker-flow-proxy", "server"]

COPY haproxy.cfg /cfg/haproxy.cfg
COPY haproxy.tmpl /cfg/tmpl/haproxy.tmpl
COPY docker-flow-proxy /usr/local/bin/docker-flow-proxy
RUN chmod +x /usr/local/bin/docker-flow-proxy
