## Stremio Streaming Server
FROM node:14.15.0-alpine as stremio-server

WORKDIR /stremio

ARG VERSION=master

RUN apk add --no-cache wget ffmpeg
RUN wget http://dl.strem.io/four/${VERSION}/server.js
RUN wget http://dl.strem.io/four/${VERSION}/stremio.asar

# apply patch to skip CORS headers verification
# see: https://github.com/sleeyax/stremio-streaming-server/issues/5
RUN sed -i 's/if (ok) enginefs.sendCORSHeaders/if (true) enginefs.sendCORSHeaders/g' server.js

# Fix for 415 Unsupported Media Type
# https://github.com/n0bodysec/docker-images/discussions/3#discussioncomment-2272314
RUN sed -i -E "s|(var first = req\.params\.first)|if (req.params.first === 'hlsv2') { req.params.first = req.query.mediaURL.split('/')[3]; req.params.second = req.query.mediaURL.split('/')[4]; }\n    \1|" server.js
RUN sed -i -E 's/HLS.masterMultiPlaylistMiddleware\)/HLS.masterPlaylistMiddleware\)/' server.js

VOLUME ["/root/.stremio-server"]

EXPOSE 11470

ENTRYPOINT [ "node", "server.js" ]

## Stremio Web Interface
FROM node:16-alpine as stremio-web

WORKDIR /project

RUN apk add --update --no-cache \
    git bash
RUN git clone https://github.com/Stremio/stremio-web.git stremio-web

COPY ./server.js /project/stremio-web/server.js

WORKDIR /project/stremio-web

RUN npm i
RUN npm run build

EXPOSE 8080

ENTRYPOINT [ "node", "server.js" ]
