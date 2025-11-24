# Stage 1: Build the Angular app
FROM node:18 AS builder

WORKDIR /app

COPY . .
RUN npm ci

# Create proper JSON config
RUN mkdir -p config && echo '{\n\
  "ui": {\n\
    "ssl": false,\n\
    "host": "elibrary.dimtmw.com",\n\
    "port": 80,\n\
    "nameSpace": "/"\n\
  },\n\
  "rest": {\n\
    "ssl": false,\n\
    "host": "api.elibrary.dimtmw.com",\n\
    "port": 80,\n\
    "nameSpace": "/server"\n\
  }\n\
}' > config/config.prod.json

RUN npm run build:prod

# Stage 2: Serve using nginx
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY --from=builder /app/config/config.prod.json /usr/share/nginx/html/assets/config.json
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]