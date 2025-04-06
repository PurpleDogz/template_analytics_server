FROM nginx:alpine

# Remove the default Nginx configuration
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

# Copy our custom Nginx configuration
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Move default nginx files to a backup location
RUN mv /usr/share/nginx/html /usr/share/nginx/html_off

# Copy built assets from dist folder
COPY dist/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]