
#### Summary

Transaction: reduce error

Without transaction, data can become inconsistent in many ways:
- Denormalized data goes out of sync with source data
- Figure out complex interacting accesses

Isolation level
- read committed
- snapshot isolation = repeatable read
- serializable

Race conditions
- Dirty reads
    - Reads uncommited.
    - Prevent: >= read committed isolation
- Dirty writes
    - overwrite data that others write but not committed
    - Prevent: almost any implementation prevents
- Read skew (non-repeatable read)
    - Prevent: >= snapshot isolation
    - Implement: multi-version concurrency control (MVCC)
-  Lost Update
    -  Two threads: read-modify-write. One overwrites others.
    -  Prevent: some snapshot isolation can prevent. Others require lock (SELECT FOR UPDATE)
-  Write skew
    - Transaction reads, decides, then writes, but the premise has changed.
    - Prevent: only serializable isolation
- Phantom read
    - A transaction reads object matches conditions. Another client writes and affetcs.
    - Prevent: only serializable isolation. But phantoms in the context of write skew requires special treatment: such as index-range locks
