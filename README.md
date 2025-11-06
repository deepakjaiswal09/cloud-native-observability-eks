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

| **#** | **Screenshot**                                                                                                  | **Description / Purpose**                                                                          |
| :---: | :----------------------------------------------------------------------------------------------------------     | :------------------------------------------------------------------------------------------------- |
|  1️⃣  | ![Node Exporter Metrics](https://github.com/user-attachments/assets/04e45e1f-fb0a-4b19-b21e-101921524ca1)        | Raw metrics from Node Exporter endpoint (`:9100/metrics`) verifying Prometheus scraping.           |
|  2️⃣  | ![Prometheus Services](https://github.com/user-attachments/assets/52a315c4-961d-48db-93e6-8ab1ededdcaf)          | `kubectl get svc -n monitoring` showing Prometheus, Grafana & Alertmanager LoadBalancer endpoints. |
|  3️⃣  | ![Prometheus Query](https://github.com/user-attachments/assets/c70ab63f-65ef-47af-9b85-f4727bd6fa27)             | Prometheus UI validating live data via `node_filesystem_readonly` query.                           |
|  4️⃣  | ![Grafana K8s Dashboard 1](https://github.com/user-attachments/assets/c17b5455-d88c-4d91-95ca-08cf95a723c2)      | Grafana dashboard visualizing Kubernetes cluster CPU, memory, and pod stats.                       |
|  5️⃣  | ![Grafana K8s Dashboard 2](https://github.com/user-attachments/assets/d50594d4-e3d5-483f-a714-473621c55166)      | Additional Grafana panel showing node-level metrics and resource usage.                            |


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

| **#** | **Screenshot**                                                                                                   | **Description / Purpose**                                                        |
| :---: | :--------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------- |
|  1️⃣  | ![EFK Deployment](https://github.com/user-attachments/assets/a35a4ad6-6f5f-4ed5-a0d2-77f83c233bb2)               | Deployed Elasticsearch, Kibana and Fluent Bit using `efk-minimal.yaml`.          |
|  2️⃣  | ![Kibana Service](https://github.com/user-attachments/assets/4a24334a-c57f-4ed9-aa82-c5ec528671a6)               | Verified Kibana LoadBalancer endpoint for external access.                       |
|  3️⃣  | ![Kibana UI Access](https://github.com/user-attachments/assets/23788c51-945f-4d97-b0cb-29450976ea76)             | Successful login to Kibana home screen with Observability and Analytics modules. |
|  4️⃣  | ![Kibana E-commerce Dashboard](https://github.com/user-attachments/assets/acb25f78-aea0-454d-8abd-f05407c69662)  | Sample E-commerce dashboard to verify visualizations and Elasticsearch queries.  |
|  5️⃣  | ![E-commerce Logs](https://github.com/user-attachments/assets/cc269002-6ec6-4462-9f15-ebbb2cc5a189)              | Log records from sample E-commerce dataset displayed in Kibana Discover.         |
|  6️⃣  | ![Fluent Bit K8s Log Dashboard](https://github.com/user-attachments/assets/7a10f2c8-b1d6-4967-9e49-370320016b58) | Custom Kibana dashboard showing Kubernetes logs streamed via Fluent Bit.         |
|  7️⃣  | ![Log Visualization](https://github.com/user-attachments/assets/f78f7511-afbe-46f3-85b3-b32bb7cce58b)            | Time-series visualization of log volume and document count over time.            |

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

| **#** | **Screenshot**                                                                                          | **Description / Purpose**                                                |
| :---: | :------------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------------- |
|  1️⃣  | ![Jaeger UI Reference](https://github.com/user-attachments/assets/61d2deb6-331c-4084-92c9-285ea3712c9b) | Reference UI for Jaeger distributed tracing dashboard (Concept Preview). |

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

- ✅ Implemented the **Observability Triad** — Metrics, Logs, and Traces
- ✅ Deployed **Prometheus–Grafana** and **EFK** stack on AWS EKS
- ✅ Visualized both sample app (E-commerce) and cluster-level data
- ✅ Understood **Jaeger** tracing flow (conceptually)
- ✅ Learned resource cleanup and AWS cost optimization

---

## 🚀 Future Enhancements

* Deploy **Jaeger** for full tracing integration
* Add **Alertmanager** with Slack integration
* Automate setup using **Helm values & Terraform**
* Integrate **CI/CD pipelines** for observability as code

---

## 🧑‍💻 Author

- **Deepak Jaiswal**
- *SRE Intern (Aspirant) | AWS EKS • Observability • Cloud-Native DevOps*
- 📧 **[deepakjaiswal9238@gmail.com](mailto:deepakjaiswal9238@gmail.com)**
- 🔗 [LinkedIn](https://www.linkedin.com/in/deepakjaiswal09/)
- [GitHub](https://github.com/deepakjaiswal09)

---
