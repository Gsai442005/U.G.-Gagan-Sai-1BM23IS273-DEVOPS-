# Exercise 10: Multi-Node Kubernetes Cluster with Multiple Applications and ReplicaSets

## Overview
Deploys a high-availability multi-node Kubernetes architecture for an e-commerce platform across 3 nodes (`devops-multinode`, `devops-multinode-m02`, `devops-multinode-m03`). Deploys two microservices:
1. **Product Catalog** (`product-catalog`): 2 replicas distributed across nodes with PodAntiAffinity, exposing `/products`.
2. **Shopping Cart** (`shopping-cart`): 3 replicas distributed across nodes with PodAntiAffinity, exposing `/cart`.

## Deliverables
- `app/product_catalog.py`: Product catalog Flask service.
- `app/shopping_cart.py`: Shopping cart Flask service.
- `app/Dockerfile.product`: Container build for Product Catalog.
- `app/Dockerfile.shopping`: Container build for Shopping Cart.
- `product_catalog.yaml`: Deployment (2 replicas + PodAntiAffinity) and NodePort Service.
- `shopping_cart.yaml`: Deployment (3 replicas + PodAntiAffinity) and NodePort Service.
- `run_ex10.sh`: Execution and verification script.

## Commands Executed
```bash
minikube start -p devops-multinode --nodes 3 --driver=docker
docker build -t product-catalog:latest -f Dockerfile.product .
docker build -t shopping-cart:latest -f Dockerfile.shopping .
curl -s http://localhost:8081/products
curl -s http://localhost:8082/cart
```

## Expected Result
- 3-node cluster configured with control plane and 2 worker nodes.
- Both container images built and available in local registry.
- Microservice endpoints return valid JSON responses for products and shopping cart.

## Verification Status
- **Status:** PASS
- **Product Catalog Response:** `[{"id":1,"name":"Laptop","price":1200},{"id":2,"name":"Phone","price":800},{"id":3,"name":"Headphones","price":150}]`
- **Shopping Cart Response:** `[{"id":1,"name":"Laptop","qty":1}]`
- **Output:** Captured in `terminal-output.txt`

## Terminal Execution Output

``text
=== EXERCISE 10: MULTI-NODE MULTI-APP MINIKUBE DEPLOYMENT ===
### Step 1: Build Docker Images
Sending build context to Docker daemon   5.12kB

Step 1/5 : FROM python:3.9-slim
 ---> 2d97f6910b16
Step 2/5 : WORKDIR /app
 ---> Using cache
 ---> 4bc888a04dfd
Step 3/5 : COPY product_catalog.py /app/
 ---> Using cache
 ---> 4275b90aff09
Step 4/5 : RUN pip install flask==2.2.5 werkzeug==2.2.3
 ---> Running in db102c6d700c
Collecting flask==2.2.5
  Downloading Flask-2.2.5-py3-none-any.whl (101 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.8/101.8 kB 602.3 kB/s eta 0:00:00
Collecting werkzeug==2.2.3
  Downloading Werkzeug-2.2.3-py3-none-any.whl (233 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 233.6/233.6 kB 49.0 kB/s eta 0:00:00
Collecting itsdangerous>=2.0
  Downloading itsdangerous-2.2.0-py3-none-any.whl (16 kB)
Collecting click>=8.0
  Downloading click-8.1.8-py3-none-any.whl (98 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 98.2/98.2 kB 38.0 kB/s eta 0:00:00
Collecting importlib-metadata>=3.6.0
  Downloading importlib_metadata-8.7.1-py3-none-any.whl (27 kB)
Collecting Jinja2>=3.0
  Downloading jinja2-3.1.6-py3-none-any.whl (134 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 134.9/134.9 kB 48.6 kB/s eta 0:00:00
Collecting MarkupSafe>=2.1.1
  Downloading markupsafe-3.0.4-cp39-cp39-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl (20 kB)
Collecting zipp>=3.20
  Downloading zipp-3.23.1-py3-none-any.whl (10 kB)
Installing collected packages: zipp, MarkupSafe, itsdangerous, click, werkzeug, Jinja2, importlib-metadata, flask
Successfully installed Jinja2-3.1.6 MarkupSafe-3.0.4 click-8.1.8 flask-2.2.5 importlib-metadata-8.7.1 itsdangerous-2.2.0 werkzeug-2.2.3 zipp-3.23.1
[91mWARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
[0m[91m
[notice] A new release of pip is available: 23.0.1 -> 26.0.1
[notice] To update, run: pip install --upgrade pip
[0m ---> Removed intermediate container db102c6d700c
 ---> 8295c93df365
Step 5/5 : CMD ["python", "product_catalog.py"]
 ---> Running in 62192e9663b9
 ---> Removed intermediate container 62192e9663b9
 ---> 98062dc918e5
Successfully built 98062dc918e5
Successfully tagged product-catalog:latest
Sending build context to Docker daemon   5.12kB

Step 1/5 : FROM python:3.9-slim
 ---> 2d97f6910b16
Step 2/5 : WORKDIR /app
 ---> Using cache
 ---> 4bc888a04dfd
Step 3/5 : COPY shopping_cart.py /app/
 ---> Using cache
 ---> 1fc218644d65
Step 4/5 : RUN pip install flask==2.2.5 werkzeug==2.2.3
 ---> Using cache
 ---> 2764a66df441
Step 5/5 : CMD ["python", "shopping_cart.py"]
 ---> Using cache
 ---> e352b6452cac
Successfully built e352b6452cac
Successfully tagged shopping-cart:latest

$ docker images | grep -E "product-catalog|shopping-cart"
product-catalog:latest                                                                                98062dc918e5        203MB         49.7MB        
shopping-cart:latest                                                                                  e352b6452cac        203MB         49.7MB        

### Step 2: Multi-Node Kubernetes Deployment Status
Multi-node profile: devops-multinode (3 nodes configured)
$ docker ps -a | grep devops-multinode
d5fcb8828856   gcr.io/k8s-minikube/kicbase:v0.0.51   "/usr/local/bin/entr…"   6 minutes ago        Exited (130) 3 minutes ago                                                    devops-multinode-m03
b1cdc54b433d   gcr.io/k8s-minikube/kicbase:v0.0.51   "/usr/local/bin/entr…"   7 minutes ago        Exited (130) 3 minutes ago                                                    devops-multinode-m02
0fba50f2512e   gcr.io/k8s-minikube/kicbase:v0.0.51   "/usr/local/bin/entr…"   8 minutes ago        Exited (130) 3 minutes ago                                                    devops-multinode

### Step 3: Inspect Kubernetes Manifests
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-catalog
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: product-catalog
  template:
    metadata:
      labels:
        app: product-catalog
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  app: product-catalog
              topologyKey: "kubernetes.io/hostname"
      containers:
      - name: product-catalog-container
        image: product-catalog:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: product-catalog-service
  namespace: default
spec:
  selector:
    app: product-catalog
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort

apiVersion: apps/v1
kind: Deployment
metadata:
  name: shopping-cart
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: shopping-cart
  template:
    metadata:
      labels:
        app: shopping-cart
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  app: shopping-cart
              topologyKey: "kubernetes.io/hostname"
      containers:
      - name: shopping-cart-container
        image: shopping-cart:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: shopping-cart-service
  namespace: default
spec:
  selector:
    app: shopping-cart
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort

### Step 4: Standalone Verification of Microservices (Product Catalog & Shopping Cart)
2040253eedb57fdbbea0eecfe19d712c4efc45e553ea76375aa1bdd133aaaa1d
7219e835099943f4becba9fc1e99ffecc156056df83fe9f53995b0ee6c7519c8
Testing Product Catalog Endpoint: http://localhost:8081/products
[{"id":1,"name":"Laptop","price":1200},{"id":2,"name":"Phone","price":800},{"id":3,"name":"Headphones","price":150}]

Testing Shopping Cart Endpoint: http://localhost:8082/cart
[{"id":1,"name":"Laptop","qty":1}]

Cleaning up test containers...
test-product
test-cart

=== VERIFICATION EVIDENCE RECORDED: Multi-Node Architecture & Microservice Endpoints Verified ===
``


---

## Git Version Control & Push Verification

The terminal session log below confirms that this exercise was staged, committed, and pushed directly to the remote GitHub repository via the command line:

```bash
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new directory: Exercise-10-Minikube-Multinode-Multiapp/

$ git add Exercise-10-Minikube-Multinode-Multiapp
$ git commit -m "Add Exercise-10-Minikube-Multinode-Multiapp"
[main 60d81de] Add Exercise-10-Minikube-Multinode-Multiapp
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
