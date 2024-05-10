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
    pnpm build

FROM lipanski/docker-static-website

COPY --from=build /ip.inbrowser.app/dist .
