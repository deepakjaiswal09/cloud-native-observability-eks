# 🚀 AWS EKS Observability Stack (Prometheus, Grafana, EFK, Jaeger)

## 🧩 Problem Statement

A startup runs a **Resume Builder website** that promises **99.99% uptime (SLA)** to customers.
Recently, users began reporting **slow response times and occasional downtime**.
However, the DevOps team had **no centralized visibility** into metrics, logs, or traces — making it difficult to pinpoint bottlenecks or predict failures.

To solve this, an **Observability Stack** was implemented on **Amazon EKS (Elastic Kubernetes Service)**.
This stack enables **real-time performance monitoring**, **centralized log management**, and **future-ready tracing capabilities** — ensuring SLA compliance and system reliability.

---

## 🎯 Objective

To design and deploy a **complete cloud-native observability system** that provides:

* ✅ Real-time cluster and app metrics (Prometheus & Grafana)
* ✅ Centralized logging and analytics (Fluent Bit, Elasticsearch, Kibana)
* ✅ *(Planned)* Distributed tracing of microservices (Jaeger)

---

## ⚙️ Tech Stack Overview

| Layer                  | Tool              | Purpose                             |
| ---------------------- | ----------------- | ----------------------------------- |
| Metrics                | **Prometheus**    | Scrapes cluster & workload metrics  |
| Visualization          | **Grafana**       | Visual dashboards for metrics       |
| Logging                | **Fluent Bit**    | Collects & ships logs               |
| Log Storage            | **Elasticsearch** | Centralized log database            |
| Log Analytics          | **Kibana**        | Visualize & query logs              |
| Tracing (Conceptual)** | **Jaeger**        | Distributed tracing across services |
| Platform               | **Amazon EKS**    | Managed Kubernetes cluster          |

---

## 🏗️ Architecture

![Architecture Diagram](https://github.com/user-attachments/assets/31d7c04e-cd8f-4394-9af2-5cddb9e7b6b4)

**Flow:**

1. Applications generate logs and metrics.
2. Prometheus scrapes metrics; Grafana visualizes them.
3. Fluent Bit ships logs from pods → Elasticsearch.
4. Kibana queries Elasticsearch for visualization.
5. *(Next phase)* Jaeger traces user requests across microservices.

---

## ⚡ Implementation Workflow (Pillar-by-Pillar)

---

### 🟢 **Pillar 1 — Metrics (Prometheus & Grafana)**

**Goal:** Gain real-time insights into cluster performance and application health.

#### 🧩 Steps:

1. Deployed the **Prometheus Operator** using Helm.

   ```bash
   helm install monitoring prometheus-community/kube-prometheus-stack \
     -n monitoring --create-namespace
   ```
2. Accessed Grafana using the LoadBalancer endpoint.
3. Visualized:

   * Preconfigured **E-commerce site dashboard**.
   * Kubernetes **cluster performance metrics** (CPU, memory, pod status, etc.).

#### 🖼️ Screenshots:

| Screenshot                                                                                                       | Description                                |
| ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| ![EKS Cluster](https://github.com/user-attachments/assets/76ee351c-a11f-4c6f-979c-ae3b74b91f9b)                  | EKS Cluster successfully created           |
| ![Ec2 node](<img width="1920" height="1080" alt="Screenshot (1460)" src="https://github.com/user-attachments/assets/ec7f990c-5df8-42e1-9447-63a0824a0b9a" />) | Prometheus metrics on ec2 node |




| ![Grafana Kubernetes Dashboard](screenshots/grafana-k8s-dashboard.png)                                           | Grafana visualizing EKS cluster metrics    |
| ![Prometheus Targets](screenshots/prometheus-targets.png)                                                        | Prometheus scraping Kubernetes endpoints   |

---

### 🟠 **Pillar 2 — Logs (Fluent Bit, Elasticsearch, Kibana)**

**Goal:** Centralize and analyze application logs for faster troubleshooting.

#### 🧩 Steps:

1. Created the `logging` namespace and deployed:

   ```bash
   kubectl apply -f manifests/elasticsearch-deployment.yaml
   kubectl apply -f manifests/kibana-deployment.yaml
   kubectl apply -f manifests/fluent-bit.yaml
   ```
2. Verified Elasticsearch health:

   ```bash
   kubectl -n logging exec deploy/kibana -- curl -s http://elasticsearch:9200/_cluster/health?pretty
   ```

   ✅ Status: `"green"`
3. Accessed Kibana via LoadBalancer and created an index pattern `logstash-*`.
4. Explored log data streamed by Fluent Bit from all cluster pods.

#### 🖼️ Screenshots:

| Screenshot                                                    | Description                                   |
| ------------------------------------------------------------- | --------------------------------------------- |
| ![Elasticsearch Health](screenshots/elasticsearch-health.png) | Elasticsearch cluster running (status: green) |
| ![Kibana Homepage](screenshots/kibana-home.png)               | Kibana UI on browser (LoadBalancer endpoint)  |
| ![Grafana E-commerce Dashboard](https://github.com/user-attachments/assets/633f0c56-ecf4-4c67-ba01-9f853a7cf8c1) | Preconfigured Grafana E-commerce dashboard |
| ![Kibana Index Patterns](screenshots/kibana-index.png)        | Created index pattern for `logstash-*`        |
| ![Kibana Discover](screenshots/kibana-logs.png)               | Centralized logs streamed from Fluent Bit     |
| ![CloudShell Logs](screenshots/cloudshell-commands.png)       | CloudShell output validating EFK connectivity |

---

### 🔵 **Pillar 3 — Traces (Jaeger - Conceptual Phase)**

**Goal:** Enable end-to-end request tracing across microservices.

#### 🧩 Overview:

Jaeger is the **third pillar of observability**, responsible for tracing user requests as they travel through multiple services.
It helps identify latency, failed hops, and dependencies.

#### 🧠 Conceptual Workflow:

1. Instrument microservices with **Jaeger SDKs**.
2. Traces flow through **Jaeger Agent → Collector → Query → UI**.
3. Developers visualize request paths and latency breakdowns.

#### 🧩 Planned Setup:

In the next iteration, Jaeger will be integrated into this stack using:

```bash
helm install jaeger jaegertracing/jaeger \
  -n tracing --create-namespace
```

#### 🖼️ Example Reference:

| Screenshot                                        | Description                              |
| ------------------------------------------------- | ---------------------------------------- |
| ![Jaeger UI Reference](screenshots/jaeger-ui.png) | Example of distributed tracing dashboard |

---

## 🧹 Cleanup

To avoid AWS costs, cleanup all resources:

```bash
kubectl delete ns logging monitoring
eksctl delete cluster --name observability --region us-east-1
```

For extra safety, run `cleanup.sh` to remove EBS, ELB, and orphaned ENIs.

---

## 📘 Learning Outcomes

✅ Implemented the **Observability Triad** — Metrics, Logs, and Traces
✅ Deployed **Prometheus–Grafana** and **EFK** stack on AWS EKS
✅ Visualized both sample app (E-commerce) and cluster-level data
✅ Understood **Jaeger** tracing flow (conceptually)
✅ Learned resource cleanup and AWS cost optimization

---

## 🚀 Future Enhancements

* Deploy **Jaeger** for full tracing integration
* Add **Alertmanager** with Slack integration
* Automate setup using **Helm values & Terraform**
* Integrate **CI/CD pipelines** for observability as code

---

## 🧰 Repository Structure

```
aws-eks-observability-lab/
├── README.md
├── manifests/
│   ├── elasticsearch-deployment.yaml
│   ├── kibana-deployment.yaml
│   ├── fluent-bit.yaml
│   ├── prometheus-values.yaml
│   ├── grafana-values.yaml
│   └── namespaces.yaml
├── screenshots/
│   ├── eks-cluster.png
│   ├── grafana-ecommerce.png
│   ├── grafana-k8s-dashboard.png
│   ├── elasticsearch-health.png
│   ├── kibana-logs.png
│   ├── cloudshell-commands.png
│   ├── jaeger-ui.png
│   └── architecture-diagram.png
├── cleanup.sh
└── setup-notes.md
```

---

## 🧑‍💻 Author

**Deepak Jaiswal**
*SRE Intern (Aspirant) | AWS EKS • Observability • Cloud-Native DevOps*
📧 **[deepakjaiswal9238@gmail.com](mailto:deepakjaiswal9238@gmail.com)**
🔗 [LinkedIn](https://www.linkedin.com/in/deepakjaiswal09/) | [GitHub](https://github.com/deepakjaiswal09)

---
