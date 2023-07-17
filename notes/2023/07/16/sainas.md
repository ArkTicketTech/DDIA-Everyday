P233-P242

##### Read Committed

- **No dirty read:** only read committed
  Why important? Avoid reading inconsistent partial update, or changes that may roll back due to abort

- **No dirty write:** only overwrite committed
  Can do: e.g. sell car, update listing table and send invoice. Avoid doing it on two customers
  Can not do: Lost Updates in race condition, e.g. increase counter

**Implementing read committed**

Dirty write: 
Row level lock

Dirty read: 
lock doesn't work well, since long transaction blocks read
Most DB: remember both old and new value

##### Snapshot Isolation and Repeatable Read

e.g.
Transfer money, Account A +100, Account B -100

The transaction succeeded. But the read process, read A before transaction, read B after transaction, and the total balance doesn't match

*nonrepeatable read* or *read skew*
If read again will get different result

Case that cannot tolerate this case:

- Backup process
- Analytic queries and integrity checks

*Snapshot isolation*

**Implementing snapshot isolation**

write lock, No read lock

Key principle of snapshot isolation: readers writers never blocks each other

Need to keep **multiple** versions
(*Read committed*: only two versions)

*multi-version concurrency control (MVCC)*

Each transaction has a unique incremental ID

created_by IDxxx, deleted_by IDxxx

Garbage collection

**Visibility rules for observing a consistent snapshot**

Ignore on-going, aborted, and larger transactions

**Indexes and snapshot isolation**

Approach 1: Index point to all versions, query need filter on transaction id.
Optimization: PostgreSQL not update index if different versions on the same page

Approach 2: Some DB use B-tree but use *append-only/copy-on-write*. The query doesn't need to filter index since every transaction creates a new root

**Repeatable read and naming confusion**

"Repeatable read" refers to different things in different db
(Let's just use snapshot isolation to be clear)
