FROM alpine:latest

RUN apk --no-cache add coreutils bash

COPY create_pages.sh gen_index.sh /scripts/

WORKDIR /scripts/

CMD ["bash", "create_pages.sh"]
