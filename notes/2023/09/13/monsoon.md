# Chapter 19 Data Storage
## 19.1 Replication
We can increase the read capacity of the database by creating replicas.

The replication between the leader and the followers can happen either fully synchronously, fully asynchronously, or as a combination of the two.

Conceptually, the failover mechanism needs to: detect when the leader has failed, promote the synchronous follower to be the new leader and reconfigure the other replicas to follow it, and ensure
client requests are sent to the new leader.  

## 19.2 Partitioning
Partitioning allows us to scale out a database for both reads and writes.

## 19.3 NosQL
Additionally, NoSQL stores generally don’t provide joins and rely on the data, often represented as key-value pairs or documents (e.g., JSON), to be unnormalized.

Finally, since NoSQL stores natively support partitioning for scalability purposes, they have limited support for transactions.
