# 🚀 AWS EKS Observability Stack (Prometheus, Grafana, EFK, Jaeger)

## 🧩 Problem Statement

A startup is running a **Resume Builder website** that promises **99.99% uptime (SLA)** to its users.
Recently, users have reported **slow response times and occasional outages**.
However, the DevOps team lacks centralized visibility into **metrics**, **logs**, and **traces** to diagnose these issues quickly.

To achieve **end-to-end observability**, we built a **Cloud-Native Observability Stack** on **Amazon EKS** using:

* **Prometheus** and **Grafana** for metrics and visualization
* **Fluent Bit**, **Elasticsearch**, and **Kibana (EFK)** for log aggregation
* **Jaeger (planned)** for distributed tracing

This stack helps ensure that the Resume Builder application meets its **SLA** by providing real-time monitoring, log analytics, and fault tracing.

---

## 🧠 Objective

To design and deploy a **complete observability system** for a Kubernetes-based web application that provides:

* Real-time performance monitoring
* Centralized log management
* Tracing visibility across microservices

---

## ⚙️ Tech Stack

| Layer                  | Tool                        | Purpose                                   |
| ---------------------- | --------------------------- | ----------------------------------------- |
| Metrics                | **Prometheus**              | Collects metrics from cluster & workloads |
| Visualization          | **Grafana**                 | Dashboards for performance metrics        |
| Logging                | **Fluent Bit**              | Lightweight log forwarder                 |
| Log Storage            | **Elasticsearch**           | Scalable log indexing                     |
| Log Analytics          | **Kibana**                  | Explore and visualize logs                |
| Tracing *(conceptual)* | **Jaeger**                  | Distributed tracing of requests           |
| Platform               | **Amazon EKS (Kubernetes)** | Managed Kubernetes service on AWS         |

---

## 🏗️ Architecture

![Architecture Diagram](https://github.com/user-attachments/assets/31d7c04e-cd8f-4394-9af2-5cddb9e7b6b4)

**Flow:**

1. Applications and Kubernetes system components generate metrics and logs.
2. Prometheus scrapes metrics and pushes them to Grafana dashboards.
3. Fluent Bit collects container logs and sends them to Elasticsearch.
4. Kibana queries Elasticsearch for real-time log visualization.
5. *(Future)* Jaeger traces request paths between microservices.

---

## 🚀 Setup Overview

### 1️⃣ Create the EKS Cluster

```bash
eksctl create cluster --name observability --region us-east-1
```

### 2️⃣ Deploy Monitoring Stack

```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace
```

### 3️⃣ Deploy Logging Stack (EFK)

```bash
kubectl apply -f manifests/elasticsearch-deployment.yaml
kubectl apply -f manifests/kibana-deployment.yaml
kubectl apply -f manifests/fluent-bit.yaml
```

### 4️⃣ Access Dashboards

* **Kibana** → `http://<Kibana-LoadBalancer-DNS>:5601`
* **Grafana** → `http://<Grafana-LoadBalancer-DNS>:3000`

Retrieve Grafana password:

```bash
kubectl get secret -n monitoring monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

---

## 📊 Sample Screenshots

| Screenshot                                                    | Description                          |
| ------------------------------------------------------------- | ------------------------------------ |
| ![EKS Cluster](screenshots/eks-cluster.png)                   | EKS cluster running successfully     |
| ![Grafana Dashboard](screenshots/grafana-dashboard.png)       | Live metrics from Prometheus         |
| ![Kibana Discover](screenshots/kibana-logs.png)               | Centralized log search and analytics |
| ![Elasticsearch Health](screenshots/elasticsearch-health.png) | Elasticsearch cluster health = green |
| ![CloudShell Commands](screenshots/cloudshell-commands.png)   | Validation commands and outputs      |

---

## 🧩 Third Pillar of Observability — Tracing (Jaeger)

Although not implemented hands-on yet, **Jaeger** plays a key role in distributed tracing.
It tracks user requests as they traverse multiple microservices, helping detect bottlenecks and latency sources.

In the next iteration, Jaeger will be deployed to trace HTTP requests within the Resume Builder microservices.

---

## 🧹 Cleanup

To avoid AWS charges:

```bash
kubectl delete ns logging monitoring
eksctl delete cluster --name observability --region us-east-1
```

Optional AWS resource cleanup (EBS, ELB, ENI) → `cleanup.sh`

---

## 📘 Learning Outcomes

* Understood **observability triad**: metrics, logs, and traces
* Implemented **Prometheus–Grafana** and **EFK** stack on AWS EKS
* Explored **Kibana index management** and log visualization
* Learned cluster resource cleanup and cost management
* Conceptually explored **Jaeger** tracing for microservices

---

## 🚀 Future Scope

* Deploy **Jaeger** for distributed tracing
* Integrate **Alertmanager** for Slack alerts
* Automate provisioning using **Helm Charts**
* Add **CI/CD pipeline** for continuous deployment and monitoring

---

## 🧑‍💻 Author

**Deepak Jaiswal**
- SRE Intern (Aspirant) | AWS EKS • Observability • Cloud-Native DevOps
- 📧 deepakjaiswal9238@gmail.com
- 🔗 https://www.linkedin.com/in/deepakjaiswal09/

---
