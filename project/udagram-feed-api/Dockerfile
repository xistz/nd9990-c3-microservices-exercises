FROM node:12-alpine as base

WORKDIR /app

COPY package-lock.json .
COPY package.json .

RUN npm ci

COPY . .

RUN npm run build

FROM node:12-alpine as release

WORKDIR /app

RUN addgroup -S $udagram && adduser -S feed-api -G $udagram

COPY --from=base --chown=feed-api:$udagram /app/package.json .
COPY --from=base --chown=feed-api:$udagram  /app/package-lock.json .

RUN npm ci --only=prod

COPY --from=base --chown=feed-api:$udagram  /app/www .

USER feed-api:$udagram 

CMD [ "node", "server.js" ]
