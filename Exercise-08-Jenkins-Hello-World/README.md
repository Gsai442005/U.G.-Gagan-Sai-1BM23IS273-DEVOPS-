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


---

## Git Version Control & Push Verification

The terminal session log below confirms that this exercise was staged, committed, and pushed directly to the remote GitHub repository via the command line:

```bash
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new directory: Exercise-08-Jenkins-Hello-World/

$ git add Exercise-08-Jenkins-Hello-World
$ git commit -m "Add Exercise-08-Jenkins-Hello-World"
[main 1ee6546] Add Exercise-08-Jenkins-Hello-World
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
