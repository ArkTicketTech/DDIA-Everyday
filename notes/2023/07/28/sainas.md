##### Compare-and-set

In DB without transaction:
compare-and-set operation

```sql
-- This may or may not be safe, depending on the database implementation 
UPDATE wiki_pages SET content = 'new content' 
  WHERE id = 1234 AND content = 'old content';
```

If the database allows the WHERE clause to read from an old snapshot, this may not prevent lost updates

##### Conflict resolution and replication

Replicated database: can modify concurrently on different node

Locks or compare-and-set: only work for single node, not work for multi-leader/leader less

Approach: create several versions (*siblings*) and then use A. application code/B. data structure to resolve and merge

Atomic operations can work in replicated nodes
commutative operations: different order get same result, like counter increment

LLW(last write wins) is prone to lost updates
