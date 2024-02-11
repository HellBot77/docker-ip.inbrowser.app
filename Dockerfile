FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/ip.inbrowser.app.git && \
    cd ip.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /ip.inbrowser.app
COPY --from=base /git/ip.inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm run build

FROM pierrezemb/gostatic

COPY --from=build /ip.inbrowser.app/dist /srv/http
EXPOSE 8043