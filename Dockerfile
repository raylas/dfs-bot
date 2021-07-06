FROM alpine:3.14.0
LABEL org.opencontainers.image.authors="r@rymnd.org"

COPY dfs_bot.sh /dfs_bot.sh
COPY cronjobs /etc/crontabs/root

RUN apk --no-cache add bash curl jq

CMD ["crond", "-f", "-d", "8"]