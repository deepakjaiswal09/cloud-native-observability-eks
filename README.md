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

- 1. prometheus query
     <img width="1920" height="1080" alt="prometheus-query" src="https://github.com/user-attachments/assets/c70ab63f-65ef-47af-9b85-f4727bd6fa27" />

- 2. grafana dashboard having nodes info
     <img width="1920" height="1080" alt="Screenshot (1478)" src="https://github.com/user-attachments/assets/d50594d4-e3d5-483f-a714-473621c55166" />
     <img width="1920" height="1080" alt="Screenshot (1476)" src="https://github.com/user-attachments/assets/c17b5455-d88c-4d91-95ca-08cf95a723c2" />
     
- 3. prometheus services
     <img width="1920" height="1080" alt="Screenshot (1472)" src="https://github.com/user-attachments/assets/52a315c4-961d-48db-93e6-8ab1ededdcaf" />

- 4. node exporter metrics for prometheus
     <img width="1920" height="1080" alt="Screenshot (1460)" src="https://github.com/user-attachments/assets/04e45e1f-fb0a-4b19-b21e-101921524ca1" />



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

1.Deployed EFK components
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a35a4ad6-6f5f-4ed5-a0d2-77f83c233bb2" />

2.verified kibana load balancer 
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/4a24334a-c57f-4ed9-aa82-c5ec528671a6" />

3.kibana ui access 
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/23788c51-945f-4d97-b0cb-29450976ea76" />

4. e-commerce sample dashboard
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/acb25f78-aea0-454d-8abd-f05407c69662" />

5. logs of the ecommerce site
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/cc269002-6ec6-4462-9f15-ebbb2cc5a189" />

6.my kubernetes fluentbit log dashboard
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7a10f2c8-b1d6-4967-9e49-370320016b58" />

7.visualization of logs 
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/f78f7511-afbe-46f3-85b3-b32bb7cce58b" />

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
