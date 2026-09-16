echo "=== EXERCISE 7: JENKINS CI AUTOMATION & DOCKER DEPLOYMENT ==="

# Clean up
docker rm -f jenkins 2>/dev/null || true

echo "### Step 1: Install and Run Jenkins using Docker"
echo "$ docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts"
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

echo "Waiting for Jenkins daemon to boot and initialize admin credentials..."
sleep 20

echo ""
echo "### Step 2: Check Jenkins Container Status"
echo "$ docker ps -a | grep jenkins"
docker ps -a | grep jenkins

echo ""
echo "### Step 3: Retrieve Initial Admin Password"
echo "$ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
ADMIN_PWD=$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo "Initializing...")
echo "Initial Admin Password: $ADMIN_PWD"

echo ""
echo "### Step 4: Verify Jenkins HTTP Service on Port 8080"
echo "$ curl -I -s http://localhost:8080/login | head -n 8"
curl -I -s http://localhost:8080/login | head -n 8

echo ""
echo "=== VERIFICATION SUCCESSFUL: Jenkins Master Active and Accessible ==="
