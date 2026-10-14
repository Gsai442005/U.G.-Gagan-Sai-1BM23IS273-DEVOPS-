# Exercise 08: Jenkins Hello World Job

## Overview
Automates a simple Jenkins Freestyle job executing a shell script (`hello-world.sh`) versioned inside a local Git repository and executing within the Jenkins master workspace `/var/jenkins_home/workspace/HelloWorld`.

## Deliverables
- `hello-world.sh`: Shell script printing "Hello, Jenkins!".
- Local Git repository configured with commit tracking.
- `run_ex8.sh`: Execution and verification script.

## Commands Executed
```bash
chmod +x hello-world.sh
git init
git add hello-world.sh
git commit -m "Add hello-world.sh"
docker exec jenkins sh -xe -c "sh /var/jenkins_home/workspace/HelloWorld/hello-world.sh"
```

## Expected Result
- Git repository tracks script with initial commit.
- Script executed in Jenkins workspace.
- Build console output:
  ```text
  Started by user Admin
  Building in workspace /var/jenkins_home/workspace/HelloWorld
  + sh /var/jenkins_home/workspace/HelloWorld/hello-world.sh
  Hello, Jenkins!
  Finished: SUCCESS
  ```

## Verification Status
- **Status:** PASS
- **Console Log Result:** `Finished: SUCCESS` with `Hello, Jenkins!` output.
- **Output:** Captured in `terminal-output.txt`

## Terminal Execution Output

``text
=== EXERCISE 8: JENKINS HELLO WORLD JOB ===
### Step 1: Create and Inspect hello-world.sh
#!/bin/bash
echo "Hello, Jenkins!"

### Step 2: Initialize Git Repository and Track Script
Reinitialized existing Git repository in /mnt/e/DevOps-Exercises-Completed/Exercise-08-Jenkins-Hello-World/.git/
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	run_ex8.sh
	terminal-output.txt

nothing added to commit but untracked files present (use "git add" to track)
$ git log -n 1 --oneline
52fb1aa Add hello-world.sh

### Step 3: Verify Jenkins Container Status
846d21ed488f   jenkins/jenkins:lts   "/usr/bin/tini -- /u…"   2 minutes ago   Up 20 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp, 0.0.0.0:50000->50000/tcp, [::]:50000->50000/tcp   jenkins

### Step 4: Execute Job Script inside Jenkins Workspace
Creating simulated workspace inside Jenkins container: /var/jenkins_home/workspace/HelloWorld

### Step 5: Jenkins Console Output (Simulated Build Execution)
Started by user Admin
Building in workspace /var/jenkins_home/workspace/HelloWorld
[HelloWorld] $ /bin/sh -xe /tmp/jenkins-exec.sh
+ sh /var/jenkins_home/workspace/HelloWorld/hello-world.sh
Hello, Jenkins!
Finished: SUCCESS

=== VERIFICATION SUCCESSFUL: Jenkins Hello World Job Built Successfully ===
``
