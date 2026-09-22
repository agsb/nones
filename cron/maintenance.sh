#!/bin/bash

# Trigger unattended-upgrades (safe, security updates only)
unattended-upgrade -d

# Clean unused packages and cache
apt autoremove -y
apt autoclean

# Clear temporary files
rm -rf /tmp/*

# Docker cleanup
docker system prune -af --volumes

# Database (Postgres example)
sudo -u postgres psql -d mydb -c "VACUUM ANALYZE;"


