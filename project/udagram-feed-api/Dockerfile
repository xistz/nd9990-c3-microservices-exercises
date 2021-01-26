FROM node:12-alpine as base

WORKDIR /app

COPY package-lock.json .
COPY package.json .

RUN npm ci

COPY . .

RUN npm run build

FROM node:12-alpine as release

ARG user=feed
ARG group=udagram

WORKDIR /app

RUN addgroup -S ${group} && adduser -S ${user} -G ${group}

COPY --from=base --chown=${user}:${group} /app/package.json .
COPY --from=base --chown=${user}:${group}  /app/package-lock.json .

RUN npm ci --only=prod

COPY --from=base --chown=${user}:${group}  /app/www .

USER ${user}:${group} 

CMD [ "node", "server.js" ]
