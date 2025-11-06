#!/usr/bin/env bash
set -euo pipefail

NS_MONITORING="monitoring"
NS_LOGGING="logging"
RELEASE="monitoring"

echo "[+] Deleting Helm release (kube-prometheus-stack)"
helm uninstall "$RELEASE" -n "$NS_MONITORING" || true

echo "[+] Deleting namespaces"
kubectl delete ns "$NS_MONITORING" --ignore-not-found
kubectl delete ns "$NS_LOGGING" --ignore-not-found

echo "[+] Deleting stray services of type LoadBalancer (if any)"
for ns in default kube-system "$NS_MONITORING" "$NS_LOGGING"; do
  kubectl get svc -n "$ns" 2>/dev/null | awk '/LoadBalancer/ {print $1}' | \
  xargs -r -I{} kubectl delete svc {} -n "$ns"
done

echo "[✓] Cleanup requested. Some cloud LBs/ENIs may take a few minutes to disappear."
