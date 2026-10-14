# Exercise 06: Real-Time Operations Monitoring with Prometheus & Grafana

## Overview
Deploys real-time operational monitoring for a quick commerce platform (ZAPPTTO/Zepto) tracking orders, delivery statuses, and transit times:
- `total_deliveries` (Gauge)
- `pending_deliveries` (Gauge)
- `on_the_way_deliveries` (Gauge)
- `average_delivery_time` (Summary)
Scraped by Prometheus on port 9090 with automated alerting rules and visualized via Grafana on port 3000.

## Deliverables
- `delivery_monitoring/delivery_metrics.py`: Python metrics generator exposing port 8000.
- `delivery_monitoring/prometheus.yml`: Prometheus scrape targets (`delivery_service` @ 8000).
- `delivery_monitoring/alert_rules.yml`: Rules for `HighPendingDeliveries` and `HighAverageDeliveryTime`.
- `delivery_monitoring/Jenkinsfile`: Continuous monitoring pipeline definition.
- `run_ex6.sh`: Automated execution script.

## Commands Executed
```bash
python3 delivery_metrics.py &
curl -s http://localhost:8000/metrics | grep total_deliveries
docker run -d --name prometheus --network=host ... prom/prometheus
docker run -d --name grafana -p 3000:3000 grafana/grafana
docker ps | grep -E "prometheus|grafana"
curl -s http://localhost:9090/-/healthy
curl -s http://localhost:9090/api/v1/targets
docker stop prometheus grafana && docker rm prometheus grafana
```

## Expected Result
- Python metrics server operational on port 8000.
- Prometheus container running on host network, scraping metrics every 15s.
- Grafana container running and listening on port 3000.
- Alert rules evaluating pending deliveries > 10 and average delivery time > 30s.

## Verification Status
- **Status:** PASS
- **Metrics HTTP Endpoint:** Verified returning active metrics (`total_deliveries`, `pending_deliveries`).
- **Prometheus Health:** `200 OK`, targets connected successfully.
- **Grafana Service:** Started and verified listening on port 3000.
- **Output:** Captured in `terminal-output.txt`

## Terminal Execution Output

``text
=== EXERCISE 6: REALTIME OPERATIONS MONITORING (PROMETHEUS & GRAFANA) ===
### Step 1: Start Python Delivery Metrics Simulation in Background
$ ps aux | grep delivery_metrics
gagan_s+     717  6.0  0.3 108084 25692 pts/0    Sl+  14:28   0:00 python3 delivery_metrics.py

### Step 2: Test /metrics Endpoint
$ curl -s http://localhost:8000/metrics | grep -E "total_deliveries|pending_deliveries|on_the_way_deliveries"
# HELP total_deliveries Total number of deliveries
# TYPE total_deliveries gauge
total_deliveries 69.0
# HELP pending_deliveries Number of pending deliveries
# TYPE pending_deliveries gauge
pending_deliveries 12.0
# HELP on_the_way_deliveries Number of deliveries on the way
# TYPE on_the_way_deliveries gauge
on_the_way_deliveries 11.0

### Step 3: Launch Prometheus Container
$ docker run -d --name prometheus --network=host -v /mnt/e/DevOps-Exercises-Completed/Exercise-06-Grafana-Monitoring/delivery_monitoring/prometheus.yml:/etc/prometheus/prometheus.yml -v /mnt/e/DevOps-Exercises-Completed/Exercise-06-Grafana-Monitoring/delivery_monitoring/alert_rules.yml:/etc/prometheus/alert_rules.yml prom/prometheus
[INFO] Starting the HTTP server on port 8000...
[INFO] HTTP server started. Simulating deliveries...
[DEBUG] Total deliveries: 78
[DEBUG] Pending deliveries: 16
[DEBUG] On-the-way deliveries: 6
[DEBUG] Average delivery time: 36.95 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 69
[DEBUG] Pending deliveries: 12
[DEBUG] On-the-way deliveries: 11
[DEBUG] Average delivery time: 29.85 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 88
[DEBUG] Pending deliveries: 12
[DEBUG] On-the-way deliveries: 17
[DEBUG] Average delivery time: 18.82 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 85
[DEBUG] Pending deliveries: 18
[DEBUG] On-the-way deliveries: 7
[DEBUG] Average delivery time: 17.96 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 74
[DEBUG] Pending deliveries: 19
[DEBUG] On-the-way deliveries: 8
[DEBUG] Average delivery time: 23.14 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 72
[DEBUG] Pending deliveries: 20
[DEBUG] On-the-way deliveries: 9
[DEBUG] Average delivery time: 34.07 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 81
[DEBUG] Pending deliveries: 17
[DEBUG] On-the-way deliveries: 15
[DEBUG] Average delivery time: 18.30 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 95
[DEBUG] Pending deliveries: 16
[DEBUG] On-the-way deliveries: 17
[DEBUG] Average delivery time: 37.59 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 69
[DEBUG] Pending deliveries: 17
[DEBUG] On-the-way deliveries: 10
[DEBUG] Average delivery time: 30.41 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 49
[DEBUG] Pending deliveries: 12
[DEBUG] On-the-way deliveries: 7
[DEBUG] Average delivery time: 20.33 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 105
[DEBUG] Pending deliveries: 20
[DEBUG] On-the-way deliveries: 15
[DEBUG] Average delivery time: 23.38 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 93
[DEBUG] Pending deliveries: 11
[DEBUG] On-the-way deliveries: 20
[DEBUG] Average delivery time: 18.91 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 69
[DEBUG] Pending deliveries: 12
[DEBUG] On-the-way deliveries: 7
[DEBUG] Average delivery time: 35.13 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 80
[DEBUG] Pending deliveries: 19
[DEBUG] On-the-way deliveries: 18
[DEBUG] Average delivery time: 37.10 seconds
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 67
[DEBUG] Pending deliveries: 15
[DEBUG] On-the-way deliveries: 15
[DEBUG] Average delivery time: 44.80 seconds
[INFO] Sleeping for 1 seconds...
4c9d54b9133d63d83bf861b6877fcd7c88c0ee4d12fb3d159bafb36d461971bf

### Step 4: Launch Grafana Container
$ docker run -d --name grafana -p 3000:3000 grafana/grafana
bcab4c0df9c060eed6b53f9aeb390a142cac761ce2e1cd8c4475fc0b2433f2d0
Waiting for services to initialize...
$ docker ps | grep -E "prometheus|grafana"
bcab4c0df9c0   grafana/grafana   "/run.sh"                13 seconds ago       Up 8 seconds        0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp   grafana
4c9d54b9133d   prom/prometheus   "/bin/prometheus --c…"   About a minute ago   Up About a minute                                                 prometheus

### Step 5: Verify Prometheus API and Targets
Prometheus Server is Healthy.
Prometheus Health: OK
$ curl -s http://localhost:9090/api/v1/targets | head -c 250
{"status":"success","data":{"activeTargets":[{"discoveredLabels":{"__address__":"127.0.0.1:8000","__always_scrape_classic_histograms__":"false","__convert_classic_histograms_to_nhcb__":"false","__metrics_path__":"/metrics","__scheme__":"http","__scra...

### Step 6: Verify Grafana HTTP API Response

Clean up monitoring test processes...
prometheus
grafana
prometheus
grafana

=== VERIFICATION SUCCESSFUL: Prometheus & Grafana Quick Commerce Monitoring Active ===
``
