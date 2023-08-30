#### Serializable Snapshot Isolation (SSI)
Concurrency control in databases has issues like poor performance, scalability problems, and race conditions

Serializable Snapshot Isolation (SSI) offer full serializability with a minor performance penalty compared to snapshot isolation
Potentially future default concurrency control mechanism

##### Pessimistic versus Optimistic Concurrency Control
Two-phase locking: pessimistic concurrency control mechanism
Serial execution: extreme pessimism (exclusive lock on the entire database)

SSI: optimistic concurrency control
- poor performance under high contention
- Better than pessimistic techniques when there is enough spare capacity and low contention

SSI uses a consistent snapshot of the database for all transaction reads
also includes an algorithm for detecting serialization conflicts and determining the transactions to abort

##### Decisions based on an Outdated Premise
Write skew in snapshot isolation: a transaction acts based on a premise that may not be true at commit time

To provide serializable isolation, the database must identify and abort transactions that may have acted on an outdated premise
This involves detecting stale MVCC object version reads and writes that affect prior reads
