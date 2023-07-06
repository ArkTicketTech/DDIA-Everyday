P209-P219

### Rebalancing Partitions

Need rebalance:

- more throughput, need add CPU
- more data, need add disk & RAM
- failed machine

Minimum requirement:

- continue accepting reads/write
- minimal move (disk I/O)

#### Strategies for Rebalancing

**Bad: Hash mod N**
Move most data

**Good: Fixed number of partition** (Hash partitioning)
Partition by 1000, only 10 nodes. New node *steal* partition from every existing node
Only entire partitions are moved between nodes. The number of partitions does not change

Benefit: can suit different hardware
Can assign more partitions to nodes that are more powerful

Problem: fixed. Not all database support split/merge later
Have to be high enough at early stage. But too high also cause too much overhead
Hard to choose if dataset size varies

**Dynamic partitioning** (Key range, and hash partitioning)

Key-range partition: hard to decide boundaries without skew, hard to reconfig manually

Dynamic partitioning (for key-range & hash partition)
auto split, auto merge

New split can be assigned to another node

Benefit: number of partition adapts to the dataset size, avoiding too much overhead

New db: one partition, or *pre-splitting*

**Partitioning proportionally to nodes** (hash partitioning)

Dynamic partitioning: proportional to the size of the dataset
This one: proportional to the number of node

Only add partition when new node joins

New node: randomly chooses partitions, split, takes a half

"randomly chooses" needs Hash based partition (like the consistent hashing)

#### Operations: Automatic or Manual Rebalancing

fully automatic <----(gradient)------>   fully manual

Auto: convenient but unpredictable
Rebalancing is expensive

Combine with auto failure detection:
One node is slow, removed, rebalanced, making situation worse

### Request Routing

*service discovery*

Approaches:

1. Client connect to random node (e.g. round-robin load balancer), that 

2. A routing tier

3. Client knows partitions assignment and call those nodes directly

Partition assignment info is known by 1. nodes 2. routing tier 3. client

Approach 1: Cassandra and Riak: *gossip protoco*l among the nodes to disseminate any changes

Approach 2: 
Many distributed data systems rely on a separate coordination service such as ZooKeeper. ZooKeeper notifies the routing tier

#### Parallel Query Execution

*massively parallel processing* (MPP) relational database products

The MPP query optimizer breaks this complex query into a number of execution stages and partitions, which can be paralleled 

### Summary

To partition

- Key range
  Rebalance: dynamical partition, splitting big partition into two
- Hash
  Rebalance: fixed number of partitions, or dynamical partitioning

Hybrid approach:
compound key: one part to partition, another to sort

Secondary index

- Document-partitioned indexes (local index)
  read from all, scatter/gather, write to only one
- Term-partitioned indexes (global index)
  read from only one, more overhead on write
