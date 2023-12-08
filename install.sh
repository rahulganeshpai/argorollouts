# Install minikube and addons
rm -r ~/.minikube
minikube start --memory=8192mb --cpus=4
# minikube start --kubernetes-version=v1.24.13
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
kubectl label namespace default istio-injection=enabled
# Load images
minikube image load helloworld:0.0.1
minikube image load helloworld:0.0.2
minikube image load liveness:0.0.1
minikube image load liveness:0.0.2
# Install argo-rollouts
kubectl create namespace argo-rollouts
kubectl label namespace argo-rollouts istio-injection=enabled
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
