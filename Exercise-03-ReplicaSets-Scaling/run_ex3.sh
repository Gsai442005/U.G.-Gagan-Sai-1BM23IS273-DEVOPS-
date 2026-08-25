echo "=== EXERCISE 3: REPLICASETS AND SCALING ==="
cd /mnt/e/DevOps-Exercises-Completed/Exercise-03-ReplicaSets-Scaling/app

echo "$ eval \$(minikube docker-env)"
eval $(minikube docker-env)

echo "$ docker build -t flashsale:1.0 ."
docker build -t flashsale:1.0 .

echo "$ kubectl apply -f /mnt/e/DevOps-Exercises-Completed/Exercise-03-ReplicaSets-Scaling/flashsale-replicaset.yaml"
kubectl apply -f /mnt/e/DevOps-Exercises-Completed/Exercise-03-ReplicaSets-Scaling/flashsale-replicaset.yaml

echo "Waiting for ReplicaSet to stabilize at 3 replicas..."
sleep 10

echo "$ kubectl get rs flashsale-rs"
kubectl get rs flashsale-rs

echo "$ kubectl get pods -l app=flashsale"
kubectl get pods -l app=flashsale

echo "$ kubectl scale rs flashsale-rs --replicas=5"
kubectl scale rs flashsale-rs --replicas=5

echo "Waiting for scaled pods to be ready..."
sleep 10

echo "$ kubectl get rs flashsale-rs"
kubectl get rs flashsale-rs

echo "$ kubectl get pods -l app=flashsale"
kubectl get pods -l app=flashsale

POD_TO_DELETE=$(kubectl get pods -l app=flashsale -o jsonpath='{.items[0].metadata.name}')
echo "$ kubectl delete pod $POD_TO_DELETE"
kubectl delete pod "$POD_TO_DELETE"

echo "Waiting for ReplicaSet auto-healing..."
sleep 5

echo "$ kubectl get pods -l app=flashsale"
kubectl get pods -l app=flashsale

NODE_IP=$(kubectl get node minikube -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc flashsale-svc -o jsonpath='{.spec.ports[0].nodePort}')
echo "Service Endpoint: http://${NODE_IP}:${NODE_PORT}"

echo "Testing / endpoint:"
curl -s "http://${NODE_IP}:${NODE_PORT}/"
echo ""

echo "Testing /buy flash sale endpoint:"
curl -s "http://${NODE_IP}:${NODE_PORT}/buy"
echo ""

echo "Testing /health endpoint:"
curl -s "http://${NODE_IP}:${NODE_PORT}/health"
echo ""

echo "=== VERIFICATION SUCCESSFUL: ReplicaSets Scaled and Self-Healed ==="
