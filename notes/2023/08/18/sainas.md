#### Implementation of two-phase locking

Lock can be *shared mode* or *exclusive mode*

- If read: first acquire lock in shared mode. Several transaction can hold shared mode, but if one exclusive mode, all have to wait
- If write: first acquire lock in exclusive mode
- If first read then write: exclusive mode
- After acquired, it must hold until commit or abort.
  That is "two-phase" 1. acquire lock, 2. at the end, release lock

  

  
#### Performance of two-phase locking
Much worse

Due to reduce concurrency

Traditional DBs don't limit the duration of transactions, (they are designed for interactive app waiting for human input)

No limit on how long one transaction can wait for another.

Besides, One transaction can wait for several other transactions

Unstable latency. Slow at high percentiles

Is problematic when robustness is needed

Deadlocks occur much more frequently under 2PL
