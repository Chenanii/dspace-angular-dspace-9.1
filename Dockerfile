FROM node:18

# Install Python and build tools (Debian style)
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD . /app/
EXPOSE 4000

# Install node dependencies
RUN npm ci

# Increase Node memory
ENV NODE_OPTIONS="--max_old_space_size=4096"
ENV NODE_ENV=development

# Start dev server
CMD npm run serve -- --host 0.0.0.0
