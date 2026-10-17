# Self-Healing Infrastructure

## Project Overview
This DevOps project monitors an NGINX web service using Prometheus and Blackbox Exporter. Bash scripts check service health and attempt recovery when the NGINX container becomes unavailable.

## Technologies Used
- Docker
- Linux and Bash scripting
- Prometheus
- Blackbox Exporter
- NGINX
- Git and GitHub

## Project Structure
```text
self-healing-infrastructure/
├── scripts/
│   ├── health_check.sh
│   └── auto_recovery.sh
├── monitoring/
│   ├── blackbox.yml
│   └── prometheus.yml
└── README.md
```

## Components

### 1. Health Check
The `health_check.sh` script checks whether NGINX responds on port 8080 and returns a success or failure status.

### 2. Automatic Recovery
The `auto_recovery.sh` script runs the health check and attempts to start the `nginx-web` container if the check fails.

### 3. Monitoring
Prometheus collects metrics from Blackbox Exporter. Blackbox Exporter probes the NGINX service over the Docker network.

## Current Status
- Health-check and recovery scripts created
- Blackbox Exporter configuration created
- Prometheus scrape configuration created
- Monitoring and recovery testing in progress

## Future Improvements
- Configure Prometheus alert rules
- Integrate Alertmanager
- Connect alerts to an automated recovery mechanism
- Test failure scenarios and document results

## Disclaimer
This project is for learning and demonstration. Recovery behavior depends on Docker access, network configuration, and the availability of the target container.
