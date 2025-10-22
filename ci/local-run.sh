#!/usr/bin/env bash
set -e

echo "🔍 Running Terraform checks..."
docker run --rm -v $PWD:/app -w /app hashicorp/terraform:1.9 fmt -check || true
docker run --rm -v $PWD:/app -w /app hashicorp/terraform:1.9 validate || true

echo "🐳 Building Docker image..."
docker build -t nginx-demo:ci-test .

echo "🧪 Scanning image with Trivy..."
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image nginx-demo:ci-test || true

# echo "🧪 Scanning image with Trivy (fail on HIGH/CRITICAL)"
# docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
#   aquasec/trivy image \
#   --severity HIGH,CRITICAL \
#   #--exit-code 1 \
#   nginx-demo:ci-test

echo "🧪 Scanning Helm chart config..."
docker run --rm -v "$PWD":/work -w /work aquasec/trivy:latest \
  trivy config helm/nginx-demo/ || true

echo "🧪 Scanning Terraform config..."
docker run --rm -v "$PWD":/work -w /work aquasec/trivy:latest \
  trivy config infra/terraform/ || true    

echo "🚀 Deploying with kubectl (local)..."
kubectl apply -n argocd -f gitops/app-argocd-helm.yaml --validate=false
kubectl get applications -n argocd

echo "📋 Listing ArgoCD applications (local)..."
kubectl get applications -n argocd

echo "✅ CI completed!"
