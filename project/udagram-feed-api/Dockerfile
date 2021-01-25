FROM node:12-buster-slim as base

WORKDIR /app

# install dependencies
RUN apt update && \
    apt install -y zip

COPY package-lock.json .
COPY package.json .

RUN npm ci

COPY . .

RUN npm run build
