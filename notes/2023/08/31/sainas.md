
##### Detecting Stale MVCC Reads
Snapshot isolation implemented by multi-version concurrency control (MVCC), ignores uncommitted write when take snapshot

Why wait until commit time to abort a transaction?
- read-only transaction
- prev write remains uncommitted thus not stale

##### Detecting Writes That Affect Prior Reads
Instead of blocking until readers have committed, it notifies the transactions that the data they read may no longer be up to date.

##### Performance of Serializable Snapshot Isolation
Granularity affects the algorithm's performance. 
- Detailed tracking: precise but has significant bookkeeping overhead
- Less detailed tracking: faster but may lead to more unnecessary aborts

Sometimes okay for a transaction to read information overwritten by another transaction if the execution result is still serializable. 
PostgreSQL uses this theory to reduce unnecessary aborts.

Compared to two-phase locking, SSI advantage: not needing to block waiting for locks, making query latency more predictable and less variable
Appealing for read-heavy workloads.

Compared to serial execution,SSI is not limited to the throughput of a single CPU core. 
FoundationDB distributes the detection of conflicts across multiple machines, allowing very high throughput

The rate of aborts significantly affects the overall performance of SSI. 
Read-write transactions should be fairly short to avoid conflicts and aborts, but SSI is probably less sensitive to slow transactions than two-phase locking or serial execution.
