# Use a lightweight Node.js image
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Expose the port the app runs on
EXPOSE 4321

# Command to run the application
CMD ["npm", "run", "dev", "--", "--host"]