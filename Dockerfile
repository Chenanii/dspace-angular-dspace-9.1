# Stage 1: Build the Angular app
FROM node:18 AS builder

WORKDIR /app

# Clone DSpace Angular source
RUN git clone --branch dspace-9.1 --depth 1 https://github.com/DSpace/dspace-angular.git .

# Install dependencies
RUN npm ci

# Build for production
RUN npm run build:prod

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]