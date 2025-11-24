# Stage 1: Build the Angular app
FROM node:18 AS builder

WORKDIR /app

# Copy local Angular project
COPY . .

# Install dependencies
RUN npm ci

# Create config for your domain using a heredoc (clean + no VS Code errors)
RUN mkdir -p config && cat <<EOF > config/config.prod.yml
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
    "port": 80,
    "nameSpace": "/server"
  }
}
EOF

# Build Angular for production
RUN npm run build:prod

# Stage 2: Serve using nginx
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
