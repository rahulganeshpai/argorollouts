# Install Kind cluster
kind create cluster --config=./kind/kind.yaml

# Install istio and addons
ISTIO_VERSION=1.20.0
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
cd istio-${ISTIO_VERSION}
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/kiali.yaml
kubectl patch deployments.apps -n istio-system istio-ingressgateway -p '{"spec":{"template":{"spec":{"containers":[{"name":"istio-proxy","ports":[{"containerPort":8080,"hostPort":80},{"containerPort":8443,"hostPort":443}]}]}}}}'

# Create dev namespace
cd ..
kubectl apply -f namespace.yaml
kubectl label namespace default istio-injection=enabled

# Load images
kind load docker-image helloworld:0.0.1
kind load docker-image helloworld:0.0.2

# Install argo-rollouts
kubectl create namespace argo-rollouts
kubectl label namespace argo-rollouts istio-injection=enabled
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
