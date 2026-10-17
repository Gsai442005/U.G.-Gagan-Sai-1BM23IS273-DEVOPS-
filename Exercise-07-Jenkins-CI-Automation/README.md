# Exercise 07: Jenkins CI Automation Setup

## Overview
Deploys and initializes the Jenkins Long-Term Support (LTS) automation master container in Docker, exposing port 8080 (Web UI) and port 50000 (Agent communication), mounting a persistent volume (`jenkins_home`), and retrieving the initial admin security token.

## Deliverables
- `run_ex7.sh`: Automated execution and verification script.

## Commands Executed
```bash
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
docker ps -a | grep jenkins
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
curl -I http://localhost:8080/login
```

## Expected Result
- Jenkins LTS container image downloaded and started.
- Container running with healthy status and ports 8080 & 50000 exposed.
- Unique Initial Admin Password successfully generated and retrieved.
- HTTP `200 OK` on `http://localhost:8080/login`.

## Verification Status
- **Status:** PASS
- **Admin Password:** `0cb74f5b1e774eea9fe00238d69a8c79`
- **HTTP Status:** `200 OK` (Jetty 12.1.13)
- **Output:** Captured in `terminal-output.txt`

## Terminal Execution Output

``text
=== EXERCISE 7: JENKINS CI AUTOMATION & DOCKER DEPLOYMENT ===
### Step 1: Install and Run Jenkins using Docker
$ docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
846d21ed488fcff1456062cf23cf4bf7a69a5ad14143ea762ad3f354b4cb0aa7
Waiting for Jenkins daemon to boot and initialize admin credentials...

### Step 2: Check Jenkins Container Status
$ docker ps -a | grep jenkins
846d21ed488f   jenkins/jenkins:lts                   "/usr/bin/tini -- /u…"   23 seconds ago   Up 20 seconds                0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp, 0.0.0.0:50000->50000/tcp, [::]:50000->50000/tcp                                           jenkins

### Step 3: Retrieve Initial Admin Password
$ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
Initial Admin Password: 0cb74f5b1e774eea9fe00238d69a8c79

### Step 4: Verify Jenkins HTTP Service on Port 8080
$ curl -I -s http://localhost:8080/login | head -n 8
HTTP/1.1 200 OK
Server: Jetty(12.1.13)
Date: Sun, 11 Oct 2026 14:32:24 GMT
X-Content-Type-Options: nosniff
Content-Security-Policy-Report-Only: base-uri 'none'; default-src 'self'; form-action 'self'; frame-ancestors 'self'; img-src 'self' data:; script-src 'report-sample' 'self' usage.jenkins.io; style-src 'report-sample' 'self' 'unsafe-inline'; report-to content-security-policy; report-uri http://localhost:8080/content-security-policy-reporting-endpoint/jX4U0TT5Xa6O6keuPiWNVTnvlqpUy0dRehm2iZwswds=:YW5vbnltb3Vz:aHVkc29uLm1vZGVsLkh1ZHNvbg==:bG9naW4=
Content-Type: text/html;charset=utf-8
Expires: 0
Cache-Control: no-cache,no-store,must-revalidate

=== VERIFICATION SUCCESSFUL: Jenkins Master Active and Accessible ===
``


---

## Git Version Control & Push Verification

The terminal session log below confirms that this exercise was staged, committed, and pushed directly to the remote GitHub repository via the command line:

```bash
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new directory: Exercise-07-Jenkins-CI-Automation/

$ git add Exercise-07-Jenkins-CI-Automation
$ git commit -m "Add Exercise-07-Jenkins-CI-Automation"
[main 6cca8ac] Add Exercise-07-Jenkins-CI-Automation
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
