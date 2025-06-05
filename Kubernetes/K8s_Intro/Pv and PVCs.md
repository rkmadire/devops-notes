Pv and PVCs
--------------
### **Persistent Volume (PV) and Persistent Volume Claim (PVC) in Kubernetes**

Kubernetes provides a robust way to handle storage for both **stateful** and **stateless** applications using Persistent Volumes (PVs) and Persistent Volume Claims (PVCs). Here's a detailed explanation:  

---

### **Persistent Volume (PV)**  
- A **Persistent Volume** is a storage resource provisioned in the cluster that abstracts physical storage, such as NFS, AWS EBS, Azure Disk, or local disk.  
- It is **cluster-wide** and managed independently of any specific Pod or application.  

#### **Key Features:**  
1. **Pre-Provisioned Storage:** Admins create PVs, which are available for use by applications.  
2. **Dynamic Provisioning:** PVs can be dynamically created using Storage Classes.  
3. **Reusable Resource:** PVs exist even if a Pod that uses it is deleted, allowing data persistence.  

#### **Example Use Case:**  
The cluster has **1000GB of storage**, and an administrator creates a PV of **100GB** from this storage for specific use cases.  

---

### **Persistent Volume Claim (PVC)**  
- A **Persistent Volume Claim** is a request for storage by a user or application.  
- PVCs are used to claim a specific amount of storage from a PV.  

#### **Key Features:**  
1. **Request for Storage:** A PVC specifies the size of storage and access mode (e.g., ReadWriteOnce, ReadOnlyMany).  
2. **Dynamic Binding:** Kubernetes matches the PVC to an available PV or dynamically provisions one if configured.  
3. **Application-Specific Usage:** PVCs are linked to Pods, enabling them to use the requested storage.  

#### **Example Use Case:**  
From the **100GB PV**, a user creates a PVC of **5GB** for a MySQL Pod. If another Pod, such as Tomcat, needs storage, a new PVC (e.g., 10GB) can be created.  

---

### **How PV and PVC Work Together**  
1. **Persistent Volume Creation:**  
   - An administrator pre-provisions a PV or enables dynamic provisioning using a Storage Class.  
   - Example: Create a **100GB PV**.  

2. **Persistent Volume Claim Creation:**  
   - Users define a PVC to request storage.  
   - Example: Create a **5GB PVC** for a MySQL Pod.  

3. **Binding:**  
   - Kubernetes automatically binds the PVC to a suitable PV based on the requested size and access mode.  

4. **Pod Usage:**  
   - The PVC is mounted as storage for the application Pod.  
   - Example: The MySQL Pod uses the **5GB PVC** for its database storage.  

---

### **Advantages of PV and PVC**  
1. **Decoupling of Storage Management:**  
   - PVs are managed by administrators, while PVCs allow developers to request storage independently.  

2. **Data Persistence:**  
   - Data remains intact even if the Pod using the PVC is deleted.  

3. **Scalability and Flexibility:**  
   - Multiple PVCs can be created from a single PV or a pool of storage, ensuring efficient resource utilization.  

4. **Dynamic Storage Allocation:**  
   - Storage Classes enable automatic provisioning of PVs when a PVC is created.  

---

### **Example Scenario**  

- **Cluster Storage:** 1000GB  
- **Persistent Volume:** 100GB is allocated for backup.  
- **Persistent Volume Claims:**  
  1. A PVC of 5GB is created for a MySQL Pod.  
  2. Another PVC of 10GB is created for a Tomcat Pod.  

- **Remaining Storage:** The PV now has 85GB available for future PVCs.  

---

### **Summary**  
- A **Persistent Volume (PV)** is a provisioned storage resource in the cluster.  
- A **Persistent Volume Claim (PVC)** is a request for storage made by applications.  
- PVCs ensure that applications have access to the required storage from PVs while maintaining data persistence across Pod restarts.  

