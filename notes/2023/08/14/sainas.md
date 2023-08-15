
P255-P256

#### Partition
Single thread: Concurrency easy, but throughput = single CPU

Upgrade: Read-only transaction, snapshot isolation
but single-threaded still can be bottleneck

To scale to multiple CPU cores: partition
If
- One partition transaction
Allow throughphut to scale with CPU core number

- Multiple partitions transaction
Need lok-step

Cross partition transaction: overhead, slower

Single key -> partition easily
Secondary indexes -> more cross partition coordinations

#### Summary of serial execution
Viable way of achieving serializable isolation, with constraints:
- Every transaction small and fast
- Active dataset can fit in memory (if ever need disk, abort, load async, then execute. Called *anti-caching*
)
- Low throughput, handled by single CPU core. Or partitioned without cross-partition coordination
- Cross-partition coordinations are possible but with limited extent
