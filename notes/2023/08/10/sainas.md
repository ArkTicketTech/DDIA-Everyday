P253-P255

#### Encapsulating transactions
In stored procedures, database transactions were meant to hold entire user activities like booking an airline ticket.
Humans are slow. Waiting for user input is inefficient.
Most transactions are short
Interactive transactions spend time in network communication, so multiple transactions must be processed concurrently for good performance.
Stored procedures: execute quickly, without waiting for network or disk I/O.

#### Pros and cons of stored procedures
Cons:
- Different database vendors use different languages
- Managing code in a database is harder
   Difficult to debug, deploy, version control, test, connect to metrics collection system
- DB more performance sensitive. Badly written ones cause worse consequences than bad application cod

Modern implementations have overcome these issues: general-purpose languages like Java or Lua.

With in-memory data, executing all transactions on a single thread is feasible. (no I/O, no overhead of concurrency)

VoltDB: also use stored procedures for replication: no copy, but execute stored procedures.
Need it to be *deterministic*  : if use date/time, must through deterministic APIs
