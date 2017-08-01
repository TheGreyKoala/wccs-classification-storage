FROM neo4j:latest
LABEL maintainer="Tim Gremplewski <tim.gremplewski@gmail.com>"

RUN apk --no-cache add curl
COPY custom-entrypoint.sh /custom-entrypoint.sh
ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["neo4j"]
