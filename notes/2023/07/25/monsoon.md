Chapter 7 p 221 - p226
- Transaction: a simplified assumption for app designer.
- ACID property
    - Atomicity: a txn can only succeed or fail. If it fails, partial changes will be rolled-back and app can safely retry
  - Consistency: before and after txn execution the assumption made from app will not break. it's app's responsibility to keep it.
  - Isolation: concurrently executing txns will not influence each other. No data race will happen. Also be referred to as "Serializable" in DB area.
    - the "isolation" here is the strongest. In reality, we will use weaker guarantees like "Snapshot Isolation".
  - Durability: once txn is committed the data should no be forgotten due to hw/sw failures.
    - there is no absolute durability due to hw problem (bit flip, disk corruption, etc.). Replication and backup can be used to lower the risk.
- Atomicity and Isolation for Single Object
  - writing a single object may fail halfway. E.g., writing a large JSON to DB or writing a large chunk on disk. (atomicity)
  - another txn may read the JSON while it's still being written. (isolation)
  - Storage engines always provide such guarantees.
    - using a WAL (redo) log for crash recovery (atomicity)
    - using a lock on each object (isolation)
  - Other atomic/complex single-object operations: CAS and Increment
  - Single object operation should not be called as "Transaction", but there is a lot of misuse in reality so be prepared

