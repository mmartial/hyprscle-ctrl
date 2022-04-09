FROM alpine:latest
RUN apk add --no-cache bash curl iptables iproute2 perl

ARG RELEASE="https://github.com/hyprspace/hyprspace/releases/download/v0.2.2/hyprspace-v0.2.2-linux-amd64"
RUN mkdir -p /usr/local/bin/ \
  && curl -L ${RELEASE} -o /usr/local/bin/hyprspace \
  && chmod a+x /usr/local/bin/hyprspace \
  && ln -s /usr/local/bin/hyprspace /usr/bin/hyprspace

RUN mkdir /app
COPY config.yml /app
COPY repl.pl /app
COPY entrypoint.sh /app
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

