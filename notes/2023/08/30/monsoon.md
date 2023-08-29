  # Membership and Coordination Services

Zookeeper or etcd: “distributed kv stores” / “coordination and configuration service”

- Actually it’s a database…with consensus

## how is zookeeper used?

- not suited as Gen-purposed db
- Other components: HBase, Kafka, YARN… rely on zookeeper
- designed to hold small amounts of data that can fit entirely in memory
- data is replicated across nodes using total order broadcast

Zookeeper is modeled after Google’s Chubby lock service. 

## feature operations in zookeeper

- linearizable atomic operation
    
    atomic CAS: can be used to implement a lock service
    
    Several nodes can acquire lock at the same time, only one will get the lock/lease
    
- total ordering of operations
    
    every executed operations will have a zxid, which is monotonically increasing.
    
    if the CAS success, the application will get the zxid and use it as **fencing token**
    
- Failure detection
    
    client and zookeeper servers maintain a long live session with heartbeats. If no heartbeats for a period and session timeouts, then session is treated dead 
    
- Change notifications
    
    clients get notified if new values are written/deleted by other clients. this avoids polling
    

Not all features require consensus

## Allocating work to nodes

in a partitioned system, data partitions are assigned to different nodes. If new node joins or old node fails, partitions need to be rebalanced. Partition assignment and notifications can be used together to avoid consistency issues.

zookeeper should be used to store slow-changing data: such as leadership of a quorum information.

## Service discovery

zookeeper, etcd, Consul are often used for service discovery: service instance name → IP address

easy for VM to come and go. If a service starts, it can register itself to the service discovery

### DNS

DNS is similar but not linearizable but if the results from DNS is stale it’s not problematic. DNS is more reliable.

## Membership services
