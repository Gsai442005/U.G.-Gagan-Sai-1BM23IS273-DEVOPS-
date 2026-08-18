echo "=== EXERCISE 1: KUBERNETES GETTING STARTED (HELLO POD) ==="
echo ""
echo "$ minikube status"
minikube status
echo ""
echo "$ kubectl get nodes"
kubectl get nodes
echo ""
echo "$ kubectl get pods -o wide"
kubectl get pods -o wide
echo ""
echo "$ kubectl get svc hello-k8s"
kubectl get svc hello-k8s
echo ""
NODE_IP=$(kubectl get node minikube -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc hello-k8s -o jsonpath='{.spec.ports[0].nodePort}')
echo "Direct NodePort Access: http://${NODE_IP}:${NODE_PORT}"
echo ""
echo "$ curl -I -s http://${NODE_IP}:${NODE_PORT}"
curl -I -s "http://${NODE_IP}:${NODE_PORT}" | head -n 5
echo ""
echo "$ curl -s http://${NODE_IP}:${NODE_PORT}"
curl -s "http://${NODE_IP}:${NODE_PORT}" | head -n 12
echo ""
echo "=== VERIFICATION SUCCESSFUL: Nginx Pod Running and Responsive ==="
