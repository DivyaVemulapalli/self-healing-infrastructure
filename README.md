# Self-Healing Infrastructure with Docker, Prometheus and Blackbox Exporter

## Project Overview

This project demonstrates a basic self-healing infrastructure setup using Docker, Prometheus, Blackbox Exporter, NGINX, and Bash scripts.

The project monitors an NGINX web server, detects service failures, and provides a recovery script to restart the stopped container.

It demonstrates basic DevOps and monitoring concepts through a local hands-on implementation.

## Objectives

- Run services using Docker Compose.
- Monitor NGINX availability using Blackbox Exporter.
- Collect monitoring metrics using Prometheus.
- Detect when the NGINX service becomes unavailable.
- Use a Bash script to check service health and restart the stopped container.
- Verify service recovery through monitoring metrics.

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Docker | Runs applications in containers |
| Docker Compose | Manages multiple containers |
| NGINX | Sample web server |
| Prometheus | Collects monitoring metrics |
| Blackbox Exporter | Checks HTTP endpoint availability |
| Bash | Automates health checks and recovery |
| Git and GitHub | Version control and project hosting |
| KillerCoda | Linux environment for hands-on testing |

## Architecture

The project contains three main containers:

1. **NGINX:** Hosts a sample web page on port `8080`.
2. **Blackbox Exporter:** Sends HTTP probes to check NGINX availability.
3. **Prometheus:** Collects the probe results every 15 seconds.

### Monitoring and Recovery Workflow

```text
             Docker Compose
                   |
       +-----------+-----------+
       |           |           |
     NGINX     Blackbox     Prometheus
   Port 8080   Exporter     Port 9090
                   |
             HTTP Probe
                   |
             NGINX Status
                   |
          Prometheus Metric
                   |
          probe_success = 1
          (Healthy Service)

          If NGINX Stops:

          probe_success = 0
          (Service Unavailable)
                   |
          Run Recovery Script
                   |
          Restart NGINX Container
                   |
             Health Check
                   |
          Recovery Successful
```

**Note:** The recovery script is executed manually in this version. Prometheus monitors and detects failures, but it is not configured to trigger the recovery script automatically.

## Project Structure

```text
self-healing-infrastructure/
│
├── docker-compose.yml
├── README.md
│
├── monitoring/
│   ├── blackbox.yml
│   └── prometheus.yml
│
├── scripts/
│   ├── health_check.sh
│   └── auto_recovery.sh
│
└── screenshots/
    ├── 01-containers-running.png
    ├── 02-nginx-welcome-page.png
    ├── 03-blackbox-health-check.png
    ├──      04-prometheus-failure-detection.png
    ├── 05-recovery-success.png
    ├── 06-prometheus-recovered.png
    
```

## Configuration Details

### 1. Docker Compose

The `docker-compose.yml` file defines three services:

- `nginx-web`
- `blackbox-exporter`
- `prometheus`

All services are connected through a custom Docker bridge network named `monitoring`.

Port mappings:

| Service | Host Port | Container Port |
|---|---:|---:|
| NGINX | 8080 | 80 |
| Blackbox Exporter | 9115 | 9115 |
| Prometheus | 9090 | 9090 |

### 2. Prometheus Configuration

The `monitoring/prometheus.yml` file configures Prometheus to:

- Scrape metrics every 15 seconds.
- Send HTTP probes through Blackbox Exporter.
- Monitor the NGINX endpoint at `http://nginx-web:80`.
- Collect the `probe_success` metric.

Metric values:

- `1` – HTTP probe successful.
- `0` – HTTP probe failed.

### 3. Blackbox Exporter Configuration

The `monitoring/blackbox.yml` file defines an HTTP probing module named `http_2xx`.

It checks whether the target web server responds with a successful HTTP status code.

### 4. Health Check Script

The `scripts/health_check.sh` script uses `curl` to check the NGINX endpoint.

- If the endpoint responds successfully, it reports `NGINX is healthy`.
- If the endpoint is unavailable, it reports `NGINX is unhealthy`.

### 5. Recovery Script

The `scripts/auto_recovery.sh` script:

1. Executes the health check script.
2. Checks whether NGINX is healthy.
3. If NGINX is unhealthy, attempts to start the Docker container.
4. Runs the health check again.
5. Reports whether recovery succeeded or failed.

## How to Run the Project

### Prerequisites

- Docker
- Docker Compose
- Git
- Linux environment or KillerCoda playground

### Step 1: Clone the Repository

```bash
git clone https://github.com/DivyaVemulapalli/self-healing-infrastructure.git
cd self-healing-infrastructure
```

### Step 2: Start the Containers

```bash
docker-compose up -d
```

### Step 3: Verify Running Containers

```bash
docker-compose ps
```

### Step 4: Verify NGINX

```bash
curl http://localhost:8080
```

The default NGINX welcome page should be returned.

### Step 5: Check Blackbox Exporter

```bash
curl -s "http://localhost:9115/probe?target=http://nginx-web:80&module=http_2xx" | grep probe_success
```

Expected output:

```text
probe_success 1
```

### Step 6: Check Prometheus Metrics

```bash
curl -s "http://localhost:9090/api/v1/query?query=probe_success"
```

When NGINX is healthy, the metric should show `1`.

### Step 7: Simulate a Failure

Stop the NGINX container:

```bash
docker stop nginx-web
```

Wait approximately 15–20 seconds for Prometheus to perform another scrape.

Run:

```bash
curl -s "http://localhost:9090/api/v1/query?query=probe_success"
```

Expected metric value:

```text
0
```

This confirms that the monitoring setup detected the service failure.

### Step 8: Execute the Recovery Script

```bash
bash scripts/auto_recovery.sh
```

Expected output:

```text
NGINX is unhealthy
Attempting to recover NGINX
nginx-web
NGINX is healthy
Recovery successful
```

### Step 9: Verify Recovery

```bash
docker ps
```

Confirm that the `nginx-web` container is running.

After the next Prometheus scrape, check the metric again:

```bash
curl -s "http://localhost:9090/api/v1/query?query=probe_success"
```

Expected metric value:

```text
1
```

## Testing and Results

The following scenarios were tested successfully:

| Test | Expected Result | Status |
|---|---|---|
| Start Docker services | All three containers running | Passed |
| Access NGINX | Welcome page displayed | Passed |
| Blackbox HTTP probe | `probe_success = 1` | Passed |
| Stop NGINX | Container becomes unavailable | Passed |
| Prometheus failure detection | `probe_success = 0` | Passed |
| Execute recovery script | NGINX container restarted | Passed |
| Verify recovery | NGINX healthy again | Passed |
| Prometheus recovery check | `probe_success = 1` | Passed |

## Screenshots

Screenshots demonstrating the implementation and test results are available in the `screenshots/` directory.

They include:

- Running Docker containers.
- NGINX welcome page.
- Successful Blackbox health check.
- Prometheus failure detection.
- Successful execution of the recovery script.
- Prometheus detecting the recovered service.
- GitHub repository structure.

## Learning Outcomes

Through this project, I gained practical experience with:

- Running multiple containers using Docker Compose.
- Understanding Docker bridge networking.
- Monitoring HTTP service availability.
- Configuring Prometheus and Blackbox Exporter.
- Understanding the `probe_success` metric.
- Writing Bash scripts for health checks.
- Restarting stopped Docker containers through scripts.
- Testing failure detection and service recovery.
- Managing project files using Git and GitHub.

## Future Improvements

- Configure Prometheus alert rules.
- Integrate Alertmanager for notifications.
- Connect alerts to a recovery webhook.
- Trigger recovery automatically when an alert fires.
- Add Grafana dashboards for monitoring visualization.
- Extend monitoring to additional services.

## Conclusion

This project demonstrates a basic monitoring and recovery workflow using Docker, Prometheus, Blackbox Exporter, and Bash.

I successfully tested service availability monitoring, failure detection, manual recovery through a Bash script, and post-recovery verification.

It helped me understand how monitoring and automation can contribute to service reliability in DevOps environments.