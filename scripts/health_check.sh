#!/bin/bash

if curl -fsS http://localhost:8080 > /dev/null; then
    echo "NGINX is healthy"
    exit 0
else
    echo "NGINX is unhealthy"
    exit 1
fi