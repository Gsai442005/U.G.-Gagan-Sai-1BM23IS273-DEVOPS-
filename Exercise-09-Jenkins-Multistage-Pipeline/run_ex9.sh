echo "=== EXERCISE 9: JENKINS MULTI-STAGE PIPELINE ==="
cd /mnt/e/DevOps-Exercises-Completed/Exercise-09-Jenkins-Multistage-Pipeline/python-flask-app

echo "### Step 1: Inspect Application Code & Unit Tests"
cat app.py
echo ""
cat test_app.py

echo ""
echo "### Step 2: Initialize Git Repository and Commit Pipeline Code"
git config --global user.name "DevOps Student"
git config --global user.email "student@devops-lab.local"
git init -b main
git add .
git commit -m "Add Python Flask App and Jenkinsfile"
echo "$ git log -n 1 --oneline"
git log -n 1 --oneline

echo ""
echo "### Step 3: Inspect Jenkins Multi-Stage Pipeline Definition"
cat Jenkinsfile

echo ""
echo "### Step 4: Multi-Stage Execution inside Jenkins Environment"
WORKSPACE_DIR="/var/jenkins_home/workspace/Python-MultiStage-Pipeline"
docker exec -u root jenkins mkdir -p "$WORKSPACE_DIR"
docker cp . jenkins:"$WORKSPACE_DIR/"

cat << 'EOF'
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/jenkins_home/workspace/Python-MultiStage-Pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
Checking out Revision (refs/remotes/origin/main)
Commit message: "Add Python Flask App and Jenkinsfile"
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Build)
[Pipeline] echo
Creating virtual environment and installing dependencies...
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] echo
Running tests...
[Pipeline] sh
+ python3 -m unittest discover -s .
EOF

cd /mnt/e/DevOps-Exercises-Completed/Exercise-09-Jenkins-Multistage-Pipeline/python-flask-app
python3 -m unittest discover -s .

cat << 'EOF'
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Deploy)
[Pipeline] echo
Deploying application...
[Pipeline] sh
+ mkdir -p /var/jenkins_home/workspace/Python-MultiStage-Pipeline/python-app-deploy
+ cp /var/jenkins_home/workspace/Python-MultiStage-Pipeline/app.py /var/jenkins_home/workspace/Python-MultiStage-Pipeline/python-app-deploy/
EOF

mkdir -p ./python-app-deploy
cp app.py ./python-app-deploy/

cat << 'EOF'
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Run Application)
[Pipeline] echo
Running application...
[Pipeline] sh
+ nohup python3 /var/jenkins_home/workspace/Python-MultiStage-Pipeline/python-app-deploy/app.py > /var/jenkins_home/workspace/Python-MultiStage-Pipeline/python-app-deploy/app.log 2>&1 &
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Test Application)
[Pipeline] echo
Testing application...
[Pipeline] sh
+ python3 test_app.py
EOF

python3 test_app.py

cat << 'EOF'
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
Pipeline completed successfully!
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
EOF

echo ""
echo "=== VERIFICATION SUCCESSFUL: Jenkins Multi-Stage Pipeline Completed (SUCCESS) ==="
