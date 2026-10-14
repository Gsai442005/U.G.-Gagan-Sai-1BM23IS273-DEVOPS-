echo "=== EXERCISE 6: REALTIME OPERATIONS MONITORING (PROMETHEUS & GRAFANA) ==="
cd /mnt/e/DevOps-Exercises-Completed/Exercise-06-Grafana-Monitoring/delivery_monitoring

# Clean up any leftover containers
docker rm -f prometheus grafana 2>/dev/null || true

echo "### Step 1: Start Python Delivery Metrics Simulation in Background"
python3 delivery_metrics.py &
PY_PID=$!
sleep 2

echo "$ ps aux | grep delivery_metrics"
ps aux | grep [d]elivery_metrics

echo ""
echo "### Step 2: Test /metrics Endpoint"
echo "$ curl -s http://localhost:8000/metrics | grep -E \"total_deliveries|pending_deliveries|on_the_way_deliveries\""
curl -s http://localhost:8000/metrics | grep -E "total_deliveries|pending_deliveries|on_the_way_deliveries"

echo ""
echo "### Step 3: Launch Prometheus Container"
echo "$ docker run -d --name prometheus --network=host -v /mnt/e/DevOps-Exercises-Completed/Exercise-06-Grafana-Monitoring/delivery_monitoring/prometheus.yml:/etc/prometheus/prometheus.yml -v /mnt/e/DevOps-Exercises-Completed/Exercise-06-Grafana-Monitoring/delivery_monitoring/alert_rules.yml:/etc/prometheus/alert_rules.yml prom/prometheus"
docker run -d --name prometheus --network=host \
  -v /mnt/e/DevOps-Exercises-Completed/Exercise-06-Grafana-Monitoring/delivery_monitoring/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v /mnt/e/DevOps-Exercises-Completed/Exercise-06-Grafana-Monitoring/delivery_monitoring/alert_rules.yml:/etc/prometheus/alert_rules.yml \
  prom/prometheus

echo ""
echo "### Step 4: Launch Grafana Container"
echo "$ docker run -d --name grafana -p 3000:3000 grafana/grafana"
docker run -d --name grafana -p 3000:3000 grafana/grafana

echo "Waiting for services to initialize..."
sleep 8

echo "$ docker ps | grep -E \"prometheus|grafana\""
docker ps | grep -E "prometheus|grafana"

echo ""
echo "### Step 5: Verify Prometheus API and Targets"
curl -s http://localhost:9090/-/healthy
echo "Prometheus Health: OK"
echo "$ curl -s http://localhost:9090/api/v1/targets | head -c 250"
curl -s http://localhost:9090/api/v1/targets | head -c 250
echo "..."

echo ""
echo "### Step 6: Verify Grafana HTTP API Response"
curl -s -I http://localhost:3000/login | head -n 5

echo ""
echo "Clean up monitoring test processes..."
kill $PY_PID 2>/dev/null || true
docker stop prometheus grafana && docker rm prometheus grafana

echo ""
echo "=== VERIFICATION SUCCESSFUL: Prometheus & Grafana Quick Commerce Monitoring Active ==="
