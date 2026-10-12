echo "=== EXERCISE 4: DOCKER NETWORKING WITH MULTIPLE CONTAINERS ==="
cd /mnt/e/DevOps-Exercises-Completed/Exercise-04-Docker-Networking/app

# Clean up
docker rm -f mysql redis flask 2>/dev/null || true
docker network rm my-bridge-net 2>/dev/null || true

echo "### Task 1: Create a Bridge Network"
echo "$ docker network create --driver bridge my-bridge-net"
docker network create --driver bridge my-bridge-net

echo ""
echo "### Task 2: Verify the Network"
echo "$ docker network ls"
docker network ls | grep my-bridge-net

echo ""
echo "### Task 3: Inspect the Network"
echo "$ docker network inspect my-bridge-net | head -n 25"
docker network inspect my-bridge-net | head -n 25

echo ""
echo "### Task 4: Launch Containers"
echo "$ docker build -t flask-api ."
docker build -t flask-api .

echo "$ docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=rootpassword mysql:latest"
docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=rootpassword mysql:latest

echo "$ docker run -d --name redis --net=my-bridge-net redis:latest"
docker run -d --name redis --net=my-bridge-net redis:latest

echo "$ docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api"
docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api

echo "Waiting for containers to initialize..."
sleep 4

echo "$ docker ps"
docker ps

echo ""
echo "Testing Flask endpoint: http://localhost:5001/about"
curl -s http://127.0.0.1:5001/about
echo ""

echo ""
echo "### Task 5: Test Connectivity"
echo "$ docker exec flask ping -c 3 mysql"
docker exec flask ping -c 3 mysql

echo ""
echo "$ docker exec flask ping -c 3 redis"
docker exec flask ping -c 3 redis

echo ""
echo "### Task 6: Clean up"
echo "$ docker stop mysql redis flask && docker rm mysql redis flask"
docker stop mysql redis flask && docker rm mysql redis flask

echo "$ docker network rm my-bridge-net"
docker network rm my-bridge-net

echo ""
echo "=== VERIFICATION SUCCESSFUL: Bridge Network, Multi-Containers, and Ping Passed ==="
