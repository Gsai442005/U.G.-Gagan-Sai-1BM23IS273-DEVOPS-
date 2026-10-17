# Exercise 02: Deploy a Flask App on Minikube using Kubectl and YAML

## Overview
Builds a custom Python 3.8 Flask application container image directly inside Minikube's Docker daemon, and deploys it using a Kubernetes Deployment with `imagePullPolicy: Never` and a NodePort Service exposing port 15000.

## Deliverables
- `app/app.py`: Flask application listening on port 15000.
- `app/Dockerfile`: Containerfile based on python:3.8-slim.
- `flask-deployment.yaml`: Deployment and Service manifest.
- `run_ex2.sh`: Automated execution script.

## Commands Executed
```bash
eval $(minikube docker-env)
docker build -t flask-app:latest .
kubectl apply -f flask-deployment.yaml
kubectl get deployments
kubectl get pods -l app=flask-app
kubectl describe deployment flask-app
kubectl logs <pod-name>
kubectl get services
curl -s http://<NodeIP>:<NodePort>
```

## Expected Result
- Flask image built locally in Minikube's Docker daemon.
- Deployment `flask-app` with 1/1 ready replicas.
- NodePort service exposing container port 15000 externally.
- Successful HTTP curl response: `Hello from Flask on Kubernetes!`.

## Verification Status
- **Status:** PASS
- **Node IP / Port:** `http://192.168.49.2:30464`
- **Response:** `Hello from Flask on Kubernetes!`
- **Evidence:** Captured in `terminal-output.txt`

## Terminal Execution Output

``text
=== EXERCISE 2: MINIKUBE KUBECTL FLASK DEPLOYMENT ===
$ eval $(minikube docker-env)
$ docker build -t flask-app:latest .
Sending build context to Docker daemon  3.072kB

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 131B done
#1 DONE 0.1s
#2 [internal] load metadata for docker.io/library/python:3.8-slim
#2 DONE 5.7s
#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.1s
#4 [internal] load build context
#4 DONE 0.0s
#5 [1/4] FROM docker.io/library/python:3.8-slim@sha256:1d52838af602b4b5a831beb13a0e4d073280665ea7be7f69ce2382f29c5a613f
#5 resolve docker.io/library/python:3.8-slim@sha256:1d52838af602b4b5a831beb13a0e4d073280665ea7be7f69ce2382f29c5a613f 0.0s done
#5 ...
#4 [internal] load build context
#4 transferring context: 357B done
#4 DONE 0.1s
#5 [1/4] FROM docker.io/library/python:3.8-slim@sha256:1d52838af602b4b5a831beb13a0e4d073280665ea7be7f69ce2382f29c5a613f
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 0B / 29.13MB 0.2s
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 0B / 14.53MB 0.2s
#5 sha256:3971691a363796c39467aae4cdce6ef773273fe6bfc67154d01e1b589befb912 0B / 248B 0.2s
#5 sha256:030d7bdc20a63e3d22192b292d006a69fa3333949f536d62865d1bd0506685cc 0B / 3.51MB 0.2s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 2.10MB / 29.13MB 0.6s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 4.19MB / 29.13MB 0.8s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 6.29MB / 29.13MB 0.9s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 9.44MB / 29.13MB 1.2s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 11.53MB / 29.13MB 1.5s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 13.63MB / 29.13MB 1.7s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 15.73MB / 29.13MB 2.0s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 17.83MB / 29.13MB 2.3s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 19.92MB / 29.13MB 2.4s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 22.02MB / 29.13MB 2.7s
#5 sha256:3971691a363796c39467aae4cdce6ef773273fe6bfc67154d01e1b589befb912 248B / 248B 2.6s done
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 25.17MB / 29.13MB 3.0s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 27.26MB / 29.13MB 3.3s
#5 sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 29.13MB / 29.13MB 3.5s done
#5 extracting sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 1.05MB / 14.53MB 4.2s
#5 sha256:030d7bdc20a63e3d22192b292d006a69fa3333949f536d62865d1bd0506685cc 1.05MB / 3.51MB 4.2s
#5 extracting sha256:302e3ee498053a7b5332ac79e8efebec16e900289fc1ecd1c754ce8fa047fcab 0.9s done
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 2.10MB / 14.53MB 4.7s
#5 sha256:030d7bdc20a63e3d22192b292d006a69fa3333949f536d62865d1bd0506685cc 2.10MB / 3.51MB 4.7s
#5 sha256:030d7bdc20a63e3d22192b292d006a69fa3333949f536d62865d1bd0506685cc 3.51MB / 3.51MB 5.1s done
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 3.15MB / 14.53MB 5.3s
#5 extracting sha256:030d7bdc20a63e3d22192b292d006a69fa3333949f536d62865d1bd0506685cc
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 4.19MB / 14.53MB 5.4s
#5 extracting sha256:030d7bdc20a63e3d22192b292d006a69fa3333949f536d62865d1bd0506685cc 0.1s done
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 5.24MB / 14.53MB 5.6s
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 6.29MB / 14.53MB 5.7s
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 8.39MB / 14.53MB 6.0s
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 9.44MB / 14.53MB 6.2s
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 10.49MB / 14.53MB 6.3s
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 11.53MB / 14.53MB 6.5s
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 13.63MB / 14.53MB 6.6s
#5 sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 14.53MB / 14.53MB 6.7s done
#5 extracting sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d
#5 extracting sha256:a3f1dfe736c5f959143f23d75ab522a60be2da902efac236f4fb2a153cc14a5d 0.4s done
#5 DONE 7.4s
#5 [1/4] FROM docker.io/library/python:3.8-slim@sha256:1d52838af602b4b5a831beb13a0e4d073280665ea7be7f69ce2382f29c5a613f
#5 extracting sha256:3971691a363796c39467aae4cdce6ef773273fe6bfc67154d01e1b589befb912 0.0s done
#5 DONE 7.4s
#6 [2/4] WORKDIR /app
#6 DONE 0.2s
#7 [3/4] COPY . /app
#7 DONE 0.1s
#8 [4/4] RUN pip install flask
#8 3.114 Collecting flask
#8 3.307   Downloading flask-3.0.3-py3-none-any.whl (101 kB)
#8 3.476      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.7/101.7 kB 911.9 kB/s eta 0:00:00
#8 3.642 Collecting Jinja2>=3.1.2
#8 3.677   Downloading jinja2-3.1.6-py3-none-any.whl (134 kB)
#8 5.334      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 134.9/134.9 kB 76.5 kB/s eta 0:00:00
#8 5.654 Collecting Werkzeug>=3.0.0
#8 5.704   Downloading werkzeug-3.0.6-py3-none-any.whl (227 kB)
#8 12.20      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 228.0/228.0 kB 35.5 kB/s eta 0:00:00
#8 12.35 Collecting itsdangerous>=2.1.2
#8 12.40   Downloading itsdangerous-2.2.0-py3-none-any.whl (16 kB)
#8 13.28 Collecting click>=8.1.3
#8 13.33   Downloading click-8.1.8-py3-none-any.whl (98 kB)
#8 14.71      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 98.2/98.2 kB 76.6 kB/s eta 0:00:00
#8 14.85 Collecting blinker>=1.6.2
#8 14.89   Downloading blinker-1.8.2-py3-none-any.whl (9.5 kB)
#8 15.39 Collecting importlib-metadata>=3.6.0
#8 15.52   Downloading importlib_metadata-8.5.0-py3-none-any.whl (26 kB)
#8 16.19 Collecting zipp>=3.20
#8 16.22   Downloading zipp-3.20.2-py3-none-any.whl (9.2 kB)
#8 17.86 Collecting MarkupSafe>=2.0
#8 17.89   Downloading MarkupSafe-2.1.5-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (26 kB)
#8 18.22 Installing collected packages: zipp, MarkupSafe, itsdangerous, click, blinker, Werkzeug, Jinja2, importlib-metadata, flask
#8 18.63 Successfully installed Jinja2-3.1.6 MarkupSafe-2.1.5 Werkzeug-3.0.6 blinker-1.8.2 click-8.1.8 flask-3.0.3 importlib-metadata-8.5.0 itsdangerous-2.2.0 zipp-3.20.2
#8 18.63 WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
#8 20.15 
#8 20.15 [notice] A new release of pip is available: 23.0.1 -> 25.0.1
#8 20.15 [notice] To update, run: pip install --upgrade pip
#8 DONE 20.3s
#9 exporting to image
#9 exporting layers
#9 exporting layers 0.8s done
#9 exporting manifest sha256:f927713e3818b147d01cec56c33aea8f143b60f4eec11862beae268c7a0cff38 0.0s done
#9 exporting config sha256:9dde93039b7db6d9b2eb5526d949c4a51ff2c8fcee47cbd420a7c06a5a29d5eb 0.0s done
#9 naming to docker.io/library/flask-app:latest done
#9 DONE 0.9s
$ minikube image ls | grep flask-app
docker.io/library/flask-app:latest
$ kubectl apply -f /mnt/e/DevOps-Exercises-Completed/Exercise-02-Minikube-Kubectl-Flask/flask-deployment.yaml
deployment.apps/flask-app created
service/flask-app-service created
Waiting for deployment/flask-app to be ready...
Waiting for deployment "flask-app" rollout to finish: 0 of 1 updated replicas are available...
deployment "flask-app" successfully rolled out
$ kubectl get deployments
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
flask-app   1/1     1            1           1s
$ kubectl get pods -l app=flask-app
NAME                         READY   STATUS    RESTARTS   AGE
flask-app-59f7cdccb4-4ccmp   1/1     Running   0          2s
$ kubectl describe deployment flask-app | head -n 25
Name:                   flask-app
Namespace:              default
CreationTimestamp:      Sun, 11 Oct 2026 14:10:05 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=flask-app
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=flask-app
  Containers:
   flask-app:
    Image:         flask-app:latest
    Port:          15000/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
$ kubectl logs flask-app-59f7cdccb4-4ccmp | head -n 10
 * Serving Flask app 'app'
 * Debug mode: off
[31m[1mWARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.[0m
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:15000
 * Running on http://10.244.0.4:15000
[33mPress CTRL+C to quit[0m
$ kubectl get services
NAME                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)           AGE
flask-app-service   NodePort    10.105.154.121   <none>        15000:30464/TCP   3s
hello-k8s           NodePort    10.102.92.107    <none>        80:30924/TCP      2m57s
kubernetes          ClusterIP   10.96.0.1        <none>        443/TCP           6m27s
Service Endpoint: http://192.168.49.2:30464
$ curl -s http://192.168.49.2:30464
Hello from Flask on Kubernetes!
=== VERIFICATION SUCCESSFUL: Flask App Running on Kubernetes ===
``


---

## Git Version Control & Push Verification

The terminal session log below confirms that this exercise was staged, committed, and pushed directly to the remote GitHub repository via the command line:

```bash
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new directory: Exercise-02-Minikube-Kubectl-Flask/

$ git add Exercise-02-Minikube-Kubectl-Flask
$ git commit -m "Add Exercise-02-Minikube-Kubectl-Flask"
[main e4f6ecb] Add Exercise-02-Minikube-Kubectl-Flask
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
