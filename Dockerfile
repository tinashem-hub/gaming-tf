# Use the official Nginx base image
FROM nginx:latest

# Set the working directory
WORKDIR /usr/share/nginx/html

# Copy the source code from the local directory into the container
COPY . .

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
