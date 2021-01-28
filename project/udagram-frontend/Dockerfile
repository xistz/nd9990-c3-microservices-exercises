FROM node:12-alpine as build

WORKDIR /app

COPY package.json .
COPY package-lock.json .

RUN npm i -g @ionic/cli
RUN npm ci

COPY . .

RUN ionic build --prod

FROM nginx:stable-alpine as release

COPY --from=build /app/www /usr/share/nginx/html
