#!/bin/bash

DOMAIN="example.com"
ALERT="you@example.com"
EXPIRY=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null \
  | openssl x509 -noout -enddate | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s)
NOW_EPOCH=$(date +%s)
DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))
if [ "$DAYS_LEFT" -lt 15 ]; then
  echo "SSL certificate for $DOMAIN expires in $DAYS_LEFT days" \
  | mail -s "SSL Expiry Warning" $ALERT
fi


