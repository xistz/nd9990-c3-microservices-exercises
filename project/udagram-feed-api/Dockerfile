FROM node:12-alpine as base

WORKDIR /app

COPY package-lock.json .
COPY package.json .

RUN npm ci

COPY . .

RUN npm run build

FROM node:12-alpine as release

WORKDIR /app

COPY --from=base /app/package.json .
COPY --from=base /app/package-lock.json .

RUN npm ci --only=prod

COPY --from=base /app/www .

CMD [ "node", "server.js" ]
