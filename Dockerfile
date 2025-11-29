FROM docker.io/node:18-alpine

RUN apk add --update python3 make g++ && rm -rf /var/cache/apk/*

WORKDIR /app
ADD . /app/
EXPOSE 4000

RUN npm install

ENV NODE_OPTIONS="--max_old_space_size=4096"
ENV NODE_ENV=development

CMD npm run serve -- --host 0.0.0.0
