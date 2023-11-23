1. Node Ati affinity is not working simple pods 
2. it's typically used at the higher-level resource level like Deployments, StatefulSets, or DaemonSets.
3. However, if you want to use Node Anti-Affinity with individual Pods, you could use a DaemonSet, which runs a copy of a Pod on all or selected nodes.
