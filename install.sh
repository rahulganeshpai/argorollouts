# Install minikube and addons
minikube start --memory=8192mb --cpus=4
minikube addons enable metrics-server
minikube addons enable istio-provisioner
minikube addons enable istio
# Install istio and addons
ISTIO_VERSION=1.20.0
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
cd istio-${ISTIO_VERSION}
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/kiali.yaml
# Create dev namespace
cd ..
kubectl apply -f namespace.yaml
# Install argo-rollouts
kubectl create namespace argo-rollouts
kubectl label namespace argo-rollouts istio-injection=enabled
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
