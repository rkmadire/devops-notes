K8s Architecture
-------------------
### **Kubernetes Architecture**  

Kubernetes operates on a **master-slave (control plane-worker node)** architecture, where the **master components** manage the cluster, and the **slave components (worker nodes)** handle application workloads.

---

### **Master Components (Control Plane)**  
The **master node** is responsible for managing the Kubernetes cluster and its components.  

1. **Container Runtime:**  
   - The containerization technology used to run containers (e.g., Docker, CRI-O).  
   - Ensures that containers are running within the cluster.

2. **Kube-API Server:**  
   - Acts as the central management point and **validates requests** from users, administrators, or other components.  
   - Provides a REST API interface for communication with the cluster.  
   - Handles authentication and ensures that only valid commands are executed.  

3. **Kube-Scheduler:**  
   - Determines **where Pods are placed** on nodes based on hardware capacity, resource requirements, and constraints.  
   - Continuously monitors the state of the cluster and schedules Pods accordingly.  

4. **Controller Manager (or Controllers):**  
   - Ensures the cluster maintains its **desired state** (e.g., specified number of Pods or ReplicaSets).  
   - Handles control loops like DeploymentController, NodeController, and others.  

5. **etcd:**  
   - A **distributed key-value store** that stores all cluster data, including configuration, state, and metadata.  
   - Acts as the **source of truth** for the Kubernetes cluster.  
   - Contains information about:  
     - Number of nodes (slaves).  
     - Hardware details.  
     - Running, deleted, or scheduled Pods.  

---

### **Slave Components (Worker Node)**  
Worker nodes are responsible for running application workloads and reporting their status to the master.  

1. **Container Runtime:**  
   - Executes containerized applications inside Pods.  
   - Examples include Docker, CRI-O, and containerd.  

2. **Kubelet:**  
   - The **agent running on each worker node**.  
   - Responsible for:  
     - Creating Pods and managing containers inside Pods.  
     - Communicating with the Kube-Scheduler on the master for instructions.  
     - Ensuring containers are running as expected.  

3. **Kube-Proxy:**  
   - Runs as a background process on each worker node.  
   - Maintains **networking and service integration** for Pods.  
   - Ensures communication between:  
     - Pods within the same node.  
     - Pods on different nodes.  
   - Minimizes latency for microservices architecture by optimizing network routes.  

---

### **Workflow in Kubernetes Architecture**  

1. **User Interaction:**  
   - Users or administrators interact with the **Kube-API Server** to deploy applications or manage resources.  

2. **Scheduling and State Management:**  
   - The **Kube-Scheduler** assigns Pods to appropriate nodes based on resource availability.  
   - The **Controller Manager** ensures that the cluster maintains its desired state.  

3. **Data Management:**  
   - **etcd** keeps a record of all cluster-related information.  

4. **Node-Level Execution:**  
   - The **Kubelet** on worker nodes receives instructions from the master and ensures that containers are created inside Pods.  
   - The **Kube-Proxy** maintains network communication between services and Pods.  

---

### **Summary of Kubernetes Architecture**  

- **Master Node (Control Plane):**  
  - Manages the cluster and ensures it functions as expected.  
  - Includes critical components like **API Server**, **Scheduler**, **Controller Manager**, and **etcd**.  

- **Worker Nodes (Slave):**  
  - Executes application workloads inside Pods.  
  - Key components: **Kubelet**, **Kube-Proxy**, and **Container Runtime**.  
