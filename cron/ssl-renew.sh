#!/bin/bash

# using certbot
# Renew certificates (only if needed)
certbot renew --quiet
# Reload web server if renewal happened
systemctl reload nginx


