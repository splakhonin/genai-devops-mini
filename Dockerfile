# Use official Nginx image as base
FROM nginx:latest

# Copy demo HTML page
RUN echo "<h1>GenAI DevOps Demo App</h1>" > /usr/share/nginx/html/index.html

# Expose HTTP port
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]
