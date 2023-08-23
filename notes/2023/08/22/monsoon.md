## Lamport Timestamp

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c6d0651a-fcc5-47a8-a398-1863e96ed0ef/Untitled.png)

in the above example, we have

(1,1) → (1,2) →(2,2)→(3,2)→(4,2)→(5,2)→(6,1)→(6,2)

A lamport timestamp is (counter, nodeId), so that they can be compared (total order)

each client and node have a counter, starting from 0.

every time a new write happens, the counter++

client/node updates its counter if a larger value is received

the counter is carried along with req/resp  

> As long as the maximum counter value is carried along with every operation, this
scheme ensures that the ordering from the Lamport timestamps is consistent with
causality, because every causal dependency results in an increased timestamp.
> 

unlike version vectors, lamport timestamp enforces a **total order,** and it’s more compact

## Drawback of lamport timestamp

to use lamport timestamp to determine the order of operation, we must make sure all operations are recorded and collected, before processing any requests. If any node is not working, then we cannot determine the total order. 

# Total order broadcast

All recipients of the broadcast receive the messages in the **same** order

Useful for data replication (state machine replication)

total order broadcast is equivalent to consensus/linearizability
