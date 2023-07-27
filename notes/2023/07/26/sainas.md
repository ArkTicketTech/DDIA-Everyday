P242-245

#### Preventing Lost Updates
write-write conflict
1. No dirty write (previously talked about)
2. Lost update (most famous)

The later write clobbers the earlier write

examples
1. counter add 1, race condition. Should add 2 in total but only add 1
Or update account balance
(Read -> calculate -> write)
2. Change a complex value
e.g. Add element to list in JSON
(Read -> parse Json -> modify -> write)
3. Two user edit wiki page, saving changes by sending entire page to server and overwriting

##### Atomic write operations

`UPDATE counters SET value = value + 1 WHERE key = 'foo';`

This is concurrency-safe in most relational DB

If the code can be expressed in terms of atomic operation
(e.g. editing a wiki page can NOT)
But ORM makes it easy to accidentally write code that are not atomic operation

Implementation
a. exclusive lock (*cursor stability*)
b. force to be executed on single thread

##### Explicit locking

```sql
BEGIN TRANSACTION; 
SELECT * FROM figures WHERE name = 'robot' AND game_id = 222 FOR UPDATE;
-- Check whether move is valid, then update the position 
-- of the piece that was returned by the previous SELECT. UPDATE figures SET position = 'c4' WHERE id = 1234;
COMMIT;
```

 The FOR UPDATE clause indicates that the database should take a lock on all rows returned by this query

##### Automatically detecting lost updates

1. force single thread
2. Try run in parallel, if transaction manager detects lost update, then retry

Pros: efficient

But MySQL/InnoDB does not detect lost updates

It's a great feature, since no application code required.
You may forget to use  lock
