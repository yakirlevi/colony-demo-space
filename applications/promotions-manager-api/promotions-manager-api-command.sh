#!/bin/bash
echo '==> Start our api as a daemon'
cd /var/promotions-manager-api
pm2 start index.js