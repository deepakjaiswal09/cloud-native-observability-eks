#!/usr/bin/env bash
set -euo pipefail

# --- Variables
NS_MONITORING="monitoring"
NS_LOGGING="logging"
RELEASE="monitoring"
CHART="prometheus-community/kube-prometheus-stack"
REGION="us-east-1"

echo "[+] Adding Helm repos"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo update >/dev/null

echo "[+] Installing kube-prometheus-stack into namespace: $NS_MONITORING"
kubectl create ns "$NS_MONITORING" >/dev/null 2>&1 || true
# If you added a values file, include: -f manifests/kube-prom-stack-values.yaml
helm upgrade --install "$RELEASE" "$CHART" -n "$NS_MONITORING"

echo "[+] Applying EFK (Elasticsearch, Kibana, Fluent Bit)"
kubectl apply -f manifests/efk-minimal.yaml

echo "[+] Waiting for Kibana external LB..."
kubectl wait --for=condition=available deploy/kibana -n "$NS_LOGGING" --timeout=600s
LB=$(kubectl get svc kibana -n "$NS_LOGGING" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "    Kibana: http://$LB:5601"

echo "[+] Grafana admin password (random if values not set):"
kubectl get secret -n "$NS_MONITORING" "$RELEASE-grafana" -o jsonpath='{.data.admin-password}' 2>/dev/null | base64 --decode || true
echo
echo "[✓] Done"
