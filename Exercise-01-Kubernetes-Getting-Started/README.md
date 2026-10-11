# Exercise 01: Kubernetes Getting Started (Hello Pod)

## Overview
Deploys an Nginx web storefront simulating Zepto's storefront inside a local Kubernetes (Minikube) cluster using Pod and NodePort Service manifests.

## Commands Executed
```bash
minikube status
kubectl get nodes
kubectl run hello-k8s --image=nginx --port=80
kubectl get pods -o wide
kubectl expose pod hello-k8s --type=NodePort --port=80
kubectl get svc hello-k8s
curl -I http://<NodeIP>:<NodePort>
```

## Expected Result
- Minikube cluster and single node in `Ready` status.
- Pod `hello-k8s` in `Running` status with 1/1 containers ready.
- NodePort service created exposing port 80 externally.
- HTTP `200 OK` response with Nginx welcome HTML page.

## Verification Status
- **Status:** PASS
- **Node IP / Port:** `http://192.168.49.2:30924`
- **Output:** Captured in `terminal-output.txt`

## Terminal Execution Output

``text
=== EXERCISE 1: KUBERNETES GETTING STARTED (HELLO POD) ===

$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured


$ kubectl get nodes
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   4m24s   v1.37.0

$ kubectl get pods -o wide
NAME        READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
hello-k8s   1/1     Running   0          66s   10.244.0.3   minikube   <none>           <none>

$ kubectl get svc hello-k8s
NAME        TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
hello-k8s   NodePort   10.102.92.107   <none>        80:30924/TCP   53s

Direct NodePort Access: http://192.168.49.2:30924

$ curl -I -s http://192.168.49.2:30924
HTTP/1.1 200 OK
Server: nginx/1.31.6
Date: Sun, 11 Oct 2026 14:08:04 GMT
Content-Type: text/html
Content-Length: 896

$ curl -s http://192.168.49.2:30924
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>

=== VERIFICATION SUCCESSFUL: Nginx Pod Running and Responsive ===
``
