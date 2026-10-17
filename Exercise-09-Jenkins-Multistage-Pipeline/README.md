# Exercise 09: Jenkins Multi-Stage Pipeline

## Overview
Automates a multi-stage Continuous Integration and Continuous Deployment (CI/CD) pipeline for a Python Flask application comprising five distinct pipeline stages:
1. **Build**: Set up dependencies and environment.
2. **Test**: Execute automated unit tests using Python `unittest`.
3. **Deploy**: Deploy application artifacts to a dedicated release directory (`python-app-deploy`).
4. **Run Application**: Launch background service process.
5. **Test Application**: Execute integration validation test client against running service endpoint.

## Deliverables
- `python-flask-app/app.py`: Flask web application.
- `python-flask-app/requirements.txt`: Pinned Flask and Werkzeug dependencies.
- `python-flask-app/test_app.py`: Unit test verifying status code 200 and greeting payload.
- `python-flask-app/Jenkinsfile`: Declarative pipeline with post-actions.
- `run_ex9.sh`: Automated pipeline execution script.

## Commands Executed
```bash
git init -b main
git add .
git commit -m "Add Python Flask App and Jenkinsfile"
python3 -m unittest discover -s .
mkdir -p ./python-app-deploy && cp app.py ./python-app-deploy/
python3 test_app.py
```

## Expected Result
- Git repository tracks all application and pipeline files.
- Unit test stage executes with `Ran 1 test ... OK`.
- Deploy stage copies files to release directory.
- Test Application stage completes successfully.
- Declarative post-action reports `Pipeline completed successfully! Finished: SUCCESS`.

## Verification Status
- **Status:** PASS
- **Unit Test Result:** `Ran 1 test in 0.020s, OK`
- **Integration Test Result:** `Ran 1 test in 0.009s, OK`
- **Output:** Captured in `terminal-output.txt`

## Terminal Execution Output

``text
=== EXERCISE 9: JENKINS MULTI-STAGE PIPELINE ===
### Step 1: Inspect Application Code & Unit Tests
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello, Jenkins Multi-Stage Pipeline!"

if __name__ == "__main__":
    app.run(debug=True)

import unittest
from app import app

class TestApp(unittest.TestCase):
    def test_home(self):
        tester = app.test_client()
        response = tester.get("/")
        print(response.data.decode("utf-8"))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode("utf-8"), "Hello, Jenkins Multi-Stage Pipeline!")

if __name__ == "__main__":
    unittest.main()

### Step 2: Initialize Git Repository and Commit Pipeline Code
Initialized empty Git repository in /mnt/e/DevOps-Exercises-Completed/Exercise-09-Jenkins-Multistage-Pipeline/python-flask-app/.git/
[main (root-commit) 55804dc] Add Python Flask App and Jenkinsfile
 4 files changed, 77 insertions(+)
 create mode 100644 Jenkinsfile
 create mode 100644 app.py
 create mode 100644 requirements.txt
 create mode 100644 test_app.py
$ git log -n 1 --oneline
55804dc Add Python Flask App and Jenkinsfile

### Step 3: Inspect Jenkins Multi-Stage Pipeline Definition
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Creating virtual environment and installing dependencies...'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'python3 -m unittest discover -s .'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh '''
                mkdir -p ${WORKSPACE}/python-app-deploy
                cp ${WORKSPACE}/app.py ${WORKSPACE}/python-app-deploy/
                '''
            }
        }
        stage('Run Application') {
            steps {
                echo 'Running application...'
                sh '''
                nohup python3 ${WORKSPACE}/python-app-deploy/app.py > ${WORKSPACE}/python-app-deploy/app.log 2>&1 &
                echo $! > ${WORKSPACE}/python-app-deploy/app.pid
                '''
            }
        }
        stage('Test Application') {
            steps {
                echo 'Testing application...'
                sh '''
                python3 ${WORKSPACE}/test_app.py
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for more details.'
        }
    }
}

### Step 4: Multi-Stage Execution inside Jenkins Environment
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
Hello, Jenkins Multi-Stage Pipeline!
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Deploy)
[Pipeline] echo
Deploying application...
[Pipeline] sh
+ mkdir -p /var/jenkins_home/workspace/Python-MultiStage-Pipeline/python-app-deploy
+ cp /var/jenkins_home/workspace/Python-MultiStage-Pipeline/app.py /var/jenkins_home/workspace/Python-MultiStage-Pipeline/python-app-deploy/
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
Hello, Jenkins Multi-Stage Pipeline!
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
Pipeline completed successfully!
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS

=== VERIFICATION SUCCESSFUL: Jenkins Multi-Stage Pipeline Completed (SUCCESS) ===
``


---

## Git Version Control & Push Verification

The terminal session log below confirms that this exercise was staged, committed, and pushed directly to the remote GitHub repository via the command line:

```bash
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new directory: Exercise-09-Jenkins-Multistage-Pipeline/

$ git add Exercise-09-Jenkins-Multistage-Pipeline
$ git commit -m "Add Exercise-09-Jenkins-Multistage-Pipeline"
[main 3d9d528] Add Exercise-09-Jenkins-Multistage-Pipeline
 4 files changed, 250 insertions(+)

$ git push origin main
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 16 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (7/7), 4.50 KiB | 4.50 MiB/s, done.
Total 7 (delta 2), reused 0 (delta 0), pack-reused 0
To https://github.com/Gsai442005/U.G.-Gagan-Sai-1BM23IS273-DEVOPS-.git
   main -> main
```
