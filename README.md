# GenAI DevOps Mini Project

A compact, interview-ready slice of a platform:
- Kubernetes (Deployment/Service/Ingress)
- Helm packaging (why and how)
- GitOps with Argo CD (auto-sync & self-heal)
- Terraform (IaC, remote state concept)
- CI/CD (GitLab) with image scanning & linting
- Security & Compliance (RBAC, NetworkPolicy, Policy-as-Code, External Secrets via Azure Key Vault)
- Observability & SRE (kube-prometheus-stack, SLO alerts, runbook, postmortem)
- Progressive Delivery (Argo Rollouts)

> Goal: Practice end-to-end workflows and be able to explain **what** and **why** for each step — exactly like in an interview.

---

## Prerequisites

- Docker (Desktop) or Docker Engine
- `kubectl`, `helm`, `kind`
- (Optional) `argocd` CLI

---

## Day 1 — Kubernetes + Helm + GitOps + Terraform (local)

```bash
# 1) Create local cluster (kind) and install ingress-nginx
make kind-up
make ingress-install

# 2) Deploy "flat" k8s manifests
make ns
make app-apply
# Verify
kubectl get pods -n demo
kubectl get svc -n demo
kubectl get ingress -n demo

# NOTE: Add to /etc/hosts
# 127.0.0.1 nginx.local
# Then open http://nginx.local

# 3) Deploy via Helm (packaged, reusable)
make helm-install
helm list -n demo
kubectl rollout status -n demo deployment/nginx-demo

# 4) (Optional) Install Argo CD and apply GitOps Application
make argocd-install
make argocd-port-forward  # UI on http://localhost:8080
make gitops-apply

# 5) Terraform (local example)
cd infra/terraform
terraform init
terraform plan
terraform apply
