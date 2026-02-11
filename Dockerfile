# Use a modern, stable base image
#FROM node:lts-bookworm-slim
FROM arm32v7/node:20-bookworm-slim

WORKDIR /usr/src/app

# Install system dependencies for serialport
RUN apt-get update && apt-get install -y --no-install-recommends \
    udev \
    && rm -rf /var/lib/apt/lists/*

# Copy package.json and package-lock.json (if available) first to leverage Docker cache
COPY package*.json ./

# Install production dependencies only
RUN npm install --production

# Copy the rest of the application source code
COPY . .

# Expose the port your app runs on
EXPOSE 12000

# Start the application
CMD ["npm", "start"]

