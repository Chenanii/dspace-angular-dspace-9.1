# Stage 1: Build the Angular app
FROM node:18 AS builder
WORKDIR /app

# Copy project source into builder
COPY . .

# Install dependencies
RUN npm ci

# Create runtime config that will be served at /assets/config.json
RUN mkdir -p config && cat <<'EOF' > config/config.prod.json
{
  "ui": {
    "ssl": false,
    "host": "elibrary.dimtmw.com",
    "port": 80,
    "nameSpace": "/"
  },
  "rest": {
    "ssl": false,
    "host": "api.elibrary.dimtmw.com",
    "port": 8080,
    "nameSpace": "/server"
  }
}
EOF

# Build Angular (ensure your package.json has build:prod or replace with your build command)
RUN npm run build:prod

# Stage 2: Serve with nginx
FROM nginx:1.29-alpine
# Copy built site
COPY --from=builder /app/dist /usr/share/nginx/html
# Copy runtime config into assets location (Angular expects /assets/config.json)
COPY --from=builder /app/config/config.prod.json /usr/share/nginx/html/assets/config.json
# custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
