

### Serializability

- Transactions prone to race conditions
- Issues with write skew and phantoms
- Difficulties with isolation levels and detection tools

Weak isolation levels since the 1970s
Recommendation: use serializable isolation!

Serializable Isolation

- Strongest isolation level
- Guarantees transactions executed serially
- Prevents all possible race conditions

Options for Implementing Serializability

1. Actual Serial Execution
2. Two-Phase Locking (2PL)
3. Optimistic Concurrency Control techniques**

#### Actual Serial Execution
- Execute one transaction at a time, serial order
- Became feasible around 2007
- Two developments caused rethink: Cheap RAM & Short OLTP Transactions
- Implemented in VoltDB/H-Store, Redis, Datomic
- Sometimes performs better, throughput limited to a single CPU core
