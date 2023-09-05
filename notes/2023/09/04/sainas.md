
Weak isolation level leaves problem to developers
Only serializable isolation protects all

- Execute in serial order
  If execution is fast, throughput is low and single CPU core is enough. This is simple and effective
- Two-phase locking
  Standard way. Performance not so good
- SSI (serializable snapshot isolation)
  New algorithm. Optimistic approach.

  
