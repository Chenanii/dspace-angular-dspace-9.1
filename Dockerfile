# Stage 1: Build the Angular app
FROM node:18 AS builder

WORKDIR /app

# Copy your local DSpace Angular files instead of cloning
COPY . .

# Install dependencies
RUN npm ci

# Configure for your domain
RUN echo '{\n\
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
}' > config/config.prod.yml

# Build for production
RUN npm run build:prod

# Check what was created
RUN ls -la /app/dist/ || echo "No dist folder"

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]