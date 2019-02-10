#!/bin/bash
echo 'Running nginx in blocking mode for k8s'
service nginx stop
nginx -g daemon off