# Stage 1: Install production dependencies
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Create the production image
FROM node:20-alpine
WORKDIR /app

# Secure the container with a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy dependencies from stage 1
COPY --from=build /app/node_modules ./node_modules

# Copy application files
COPY server.js package.json ./

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

USER appuser

# Run server.js directly from the app root
CMD ["node", "server.js"]