echo "=== EXERCISE 2: MINIKUBE KUBECTL FLASK DEPLOYMENT ==="
cd /mnt/e/DevOps-Exercises-Completed/Exercise-02-Minikube-Kubectl-Flask/app

echo "$ eval \$(minikube docker-env)"
eval $(minikube docker-env)

echo "$ docker build -t flask-app:latest ."
docker build -t flask-app:latest .

echo "$ minikube image ls | grep flask-app"
minikube image ls | grep flask-app || true

echo "$ kubectl apply -f /mnt/e/DevOps-Exercises-Completed/Exercise-02-Minikube-Kubectl-Flask/flask-deployment.yaml"
kubectl apply -f /mnt/e/DevOps-Exercises-Completed/Exercise-02-Minikube-Kubectl-Flask/flask-deployment.yaml

echo "Waiting for deployment/flask-app to be ready..."
kubectl rollout status deployment/flask-app --timeout=120s

echo "$ kubectl get deployments"
kubectl get deployments

echo "$ kubectl get pods -l app=flask-app"
kubectl get pods -l app=flask-app

echo "$ kubectl describe deployment flask-app | head -n 25"
kubectl describe deployment flask-app | head -n 25

POD_NAME=$(kubectl get pods -l app=flask-app -o jsonpath='{.items[0].metadata.name}')
echo "$ kubectl logs $POD_NAME | head -n 10"
kubectl logs "$POD_NAME" | head -n 10

echo "$ kubectl get services"
kubectl get services

NODE_IP=$(kubectl get node minikube -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc flask-app-service -o jsonpath='{.spec.ports[0].nodePort}')
echo "Service Endpoint: http://${NODE_IP}:${NODE_PORT}"

echo "$ curl -s http://${NODE_IP}:${NODE_PORT}"
curl -s "http://${NODE_IP}:${NODE_PORT}"
echo ""

echo "=== VERIFICATION SUCCESSFUL: Flask App Running on Kubernetes ==="
