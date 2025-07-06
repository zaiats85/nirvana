FROM docker.io/library/nginx:alpine

# Copy your files
COPY ./ /
WORKDIR /srv/www

# Install OpenSSL
RUN apk add --no-cache openssl

# Create SSL directories if they don't exist
RUN mkdir -p /etc/ssl/private /etc/ssl/certs

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Generate Diffie-Hellman parameters
RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# Start nginx
CMD ["nginx", "-g", "daemon off;"]