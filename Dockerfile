FROM nginx:1.25-alpine

# Copy all files to Nginx html directory
COPY . /usr/share/nginx/html

COPY js/ /usr/share/nginx/html/js/

COPY style/ /usr/share/nginx/html/style/

# Ensure files have read permissions
RUN chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]