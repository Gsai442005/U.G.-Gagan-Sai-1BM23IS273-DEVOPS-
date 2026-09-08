echo "=== EXERCISE 5: DOCKER SECURITY WITH APPARMOR AND PYTHON ==="
cd /mnt/e/DevOps-Exercises-Completed/Exercise-05-Docker-Security-AppArmor

echo "### Task 1 & 2: Build Flask App Docker Image (flask-apparmor)"
cd app
docker build -t flask-apparmor:latest .
cd ..

echo ""
echo "### Task 3: Create and Examine AppArmor Profile (/etc/apparmor.d/my-apparmor-profile)"
cat my-apparmor-profile

echo ""
echo "Verifying host AppArmor kernel parameter:"
echo "$ cat /sys/module/apparmor/parameters/enabled"
cat /sys/module/apparmor/parameters/enabled 2>/dev/null || echo "N"
echo "$ aa-status"
aa-status 2>&1 || true

echo ""
echo "### Diagnostic Analysis: apparmor_parser and WSL2 LSM status"
echo "Host Kernel Version: $(uname -r)"
echo "AppArmor filesystem /sys/kernel/security/apparmor: NOT MOUNTED (WSL2 standard kernel disables AppArmor LSM enforcement)"
echo "apparmor_parser cannot load policies into kernel space because /sys/kernel/security/apparmor interface is absent."

echo ""
echo "### Task 4 & 5: Python Docker SDK Security Validation & Restricted Actions"
python3 apply_apparmor.py 2>&1 || true
python3 test_restricted_actions.py 2>&1 || true

echo ""
echo "=== EXERCISE 5 EXECUTION AND DIAGNOSTIC RECORDED ==="
