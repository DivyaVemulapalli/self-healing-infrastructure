#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

if bash "$SCRIPT_DIR/health_check.sh"; then
    echo "No recovery needed"
else
    echo "Attempting to recover NGINX"

    if docker start nginx-web; then
        sleep 2

        if bash "$SCRIPT_DIR/health_check.sh"; then
            echo "Recovery successful"
        else
            echo "Recovery failed: NGINX is still unhealthy"
            exit 1
        fi
    else
        echo "Recovery failed: Could not start NGINX"
        exit 1
    fi
fi