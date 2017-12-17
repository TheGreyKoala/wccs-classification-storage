FROM neo4j:3.3.1
LABEL maintainer="Tim Gremplewski <tim.gremplewski@gmail.com>"

RUN apk --no-cache add curl
COPY custom-entrypoint.sh /custom-entrypoint.sh
ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["neo4j"]
