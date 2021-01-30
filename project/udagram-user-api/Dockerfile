FROM node:12-alpine as base

WORKDIR /app

COPY package-lock.json .
COPY package.json .

RUN npm ci

COPY . .

RUN npm run build

FROM node:12-alpine as release

WORKDIR /app

RUN addgroup -S udagram && adduser -S user-api -G udagram

COPY --from=base --chown=user-api:udagram /app/package.json .
COPY --from=base --chown=user-api:udagram  /app/package-lock.json .

RUN npm ci --only=prod

COPY --from=base --chown=user-api:udagram  /app/www .

USER user-api:udagram 

CMD [ "node", "server.js" ]
