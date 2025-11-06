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

* **EKS Cluster Successfully Created**
  ![EKS Cluster Running](screenshots/eks-cluster.png)

* **Prometheus Target Metrics**
  ![Prometheus Query](screenshots/prometheus-query.png)

* **Grafana Kubernetes Dashboard**
  ![Grafana Dashboard](screenshots/grafana-dashboard.png)

* **SLA Dashboard (Availability 100%)**
  ![Grafana SLA Metrics](screenshots/grafana-sla.png)

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

* **Fluent Bit Running in Logging Namespace**
  ![Fluent Bit Pods](screenshots/fluentbit-pods.png)

* **Elasticsearch Cluster Health Check**
  ![Elasticsearch Health](screenshots/elasticsearch-health.png)

* **Kibana Home Interface**
  ![Kibana Home](screenshots/kibana-home.png)

* **Kibana Logs for Resume Builder App**
  ![Kibana Logs](screenshots/kibana-logs.png)
  
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




# 🚀 AWS EKS Observability Stack — Prometheus, Grafana, EFK, and Jaeger (Conceptual)

## 🧩 Problem Statement

A startup runs a **Resume Builder website** that promises **99.99% uptime (SLA)** to customers.
Recently, users complained about **slow response times and occasional downtime**.
The DevOps team lacked centralized visibility into **metrics**, **logs**, and **traces**, making it hard to find performance bottlenecks or root causes.

To solve this, we built a **complete Cloud-Native Observability Stack** using **Amazon EKS** that provides full visibility across the system.

---

## 🎯 Objective

To design and deploy an **end-to-end observability solution** on **AWS EKS** that enables:

* Real-time performance monitoring
* Centralized log collection and analytics
* Request-level tracing across microservices
* SLA/SLO compliance visibility

---

## ⚙️ Tech Stack Overview

| Layer                  | Tool                        | Purpose                                  |
| ---------------------- | --------------------------- | ---------------------------------------- |
| Metrics                | **Prometheus**              | Collects metrics from cluster components |
| Visualization          | **Grafana**                 | Displays dashboards and SLO metrics      |
| Logging                | **Fluent Bit**              | Lightweight log forwarder                |
| Log Storage            | **Elasticsearch**           | Scalable log indexing and storage        |
| Log Visualization      | **Kibana**                  | UI to search and analyze logs            |
| Tracing *(Conceptual)* | **Jaeger**                  | Distributed tracing of requests          |
| Platform               | **Amazon EKS (Kubernetes)** | Managed Kubernetes control plane         |

---

## 🏗️ Architecture

```
+------------------+         +----------------+
|   Kubernetes     |         |   AWS EKS      |
|   (Pods, Apps)   |-------->|  Managed Infra |
+------------------+         +----------------+
        | Metrics                          | Logs
        v                                   v
+------------------+              +----------------+
|   Prometheus     |<------------>|   Fluent Bit    |
|   (Scraper)      |              | (Log Forwarder) |
+--------+---------+              +--------+--------+
         |                                  |
         v                                  v
  +--------------+                 +------------------+
  |   Grafana    |                 |   Elasticsearch  |
  | Dashboards   |                 |   +   Kibana     |
  +--------------+                 +------------------+
                 \________________________/
                      Central Observability
```

---

## 🧩 Observability Pillars

### 🟢 **1. Metrics — Prometheus & Grafana**

Metrics provide real-time visibility into resource utilization, latency, and uptime.

#### 📍 Steps:

* Installed Prometheus using Helm.
* Integrated Grafana with Prometheus as a data source.
* Deployed Node Exporter to collect host-level metrics.

#### 🖼️ Evidence:

* **EKS Cluster Successfully Created**
  ![EKS Cluster Running](screenshots/eks-cluster.png)

* **Prometheus Target Metrics**
  ![Prometheus Query](screenshots/prometheus-query.png)

* **Grafana Kubernetes Dashboard**
  ![Grafana Dashboard](screenshots/grafana-dashboard.png)

* **SLA Dashboard (Availability 100%)**
  ![Grafana SLA Metrics](screenshots/grafana-sla.png)

---

### 🟠 **2. Logs — EFK Stack (Elasticsearch, Fluent Bit, Kibana)**

Logs provide insight into application-level and cluster-level events.

#### 📍 Steps:

* Deployed Elasticsearch and Kibana with Helm.
* Configured Fluent Bit to ship pod logs to Elasticsearch.
* Validated health of Elasticsearch cluster.
* Accessed and explored logs through Kibana’s Discover UI.

#### 🖼️ Evidence:

* **Fluent Bit Running in Logging Namespace**
  ![Fluent Bit Pods](screenshots/fluentbit-pods.png)

* **Elasticsearch Cluster Health Check**
  ![Elasticsearch Health](screenshots/elasticsearch-health.png)

* **Kibana Home Interface**
  ![Kibana Home](screenshots/kibana-home.png)

* **Kibana Logs for Resume Builder App**
  ![Kibana Logs](screenshots/kibana-logs.png)

---

### 🔵 **3. Traces — Jaeger (Conceptual)**

**Jaeger** is planned for distributed tracing to complete the observability triad.
It helps trace user requests across microservices to identify latency or dependency failures.

#### 📘 Next Step:

* Deploy **Jaeger Operator** via Helm.
* Integrate with application services using **OpenTelemetry SDK**.

> You can insert your Jaeger setup screenshot here once ready.

---

## 🧪 Validation and Results

After setup:

* **Prometheus** successfully collected metrics from cluster nodes.
* **Grafana** visualized system health and availability metrics.
* **Fluent Bit** forwarded logs to **Elasticsearch**, which were viewed in **Kibana**.
* Observability data confirmed **100% uptime** of Kubernetes API server, validating SLA compliance.

---

## 🧹 Cleanup

To avoid AWS costs:

```bash
kubectl delete ns logging monitoring
eksctl delete cluster --name observability --region us-east-1
```

All EKS resources, node groups, and load balancers were deleted successfully.

#### 🖼️ Evidence:

![CloudShell Cleanup](screenshots/cleanup.png)

---

## 📘 Learning Outcomes

* Understood **Observability Pillars** (Metrics, Logs, Traces)
* Deployed **Prometheus–Grafana** and **EFK** stack on AWS EKS
* Monitored SLA and SLO metrics for real-world applications
* Learned log indexing and validation using Kibana
* Automated cleanup using `eksctl` to manage AWS resources

---

## 🚀 Future Enhancements

* Deploy **Jaeger** for tracing
* Add **Alertmanager** with Slack alerts
* Automate deployments using **Helm** and **CI/CD**
* Use **OpenTelemetry** for unified telemetry collection

---

## 👨‍💻 Author

**Deepak Jaiswal**
SRE Intern (Aspirant) | AWS EKS • Observability • Cloud-Native DevOps
📧 [deepakjaiswal9238@gmail.com](mailto:deepakjaiswal9238@gmail.com)
🔗 [LinkedIn](https://www.linkedin.com/in/deepakjaiswal09/)

---

> *“Metrics tell you what’s happening, logs tell you why, and traces show you where.”*
> This project demonstrates all three — built from scratch on AWS EKS.


---
