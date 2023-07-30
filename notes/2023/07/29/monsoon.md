# Weak Isolation Levels

p233 - p237

- Ideal transactional level: Isolation in ACID
    - strong isolation: transactions are executed “serially” (aka. serializability)
    - performance cost, so many DBs use weaker isolation levels
- Weak isolation levels can cause bugs in real world
    - loss of money (in bitcoin exchange)
    - data corrutpion

# Read Comitted

- NO dirty read/write:

# Weak Isolation Levels

p233 - p237

- Ideal transactional level: Isolation in ACID
    - strong isolation: transactions are executed “serially” (aka. serializability)
    - performance cost, so many DBs use weaker isolation levels
- Weak isolation levels can cause bugs in real world
    - loss of money (in bitcoin exchange)
    - data corrutpion

# Read Committed

- NO dirty read/write:
    - Transactions can only read committed data, and they can only write data that will become committed
- Implementation
    - Read: maintain both old committed value and new uncommitted value
    - Write: row level write lock
- Limitation of read-committed level
    - Non-repeatable read (in long running txns like snapshotting):
        - A transaction reads a record. Another transaction then modifies or deletes that record and commits.
        - When the first transaction tries to read the same record again, it gets a different value (or no value, if the record was deleted).
        - This can cause inconsistencies in the data and lead to incorrect results.
    

# Snapshot Isolation

- Concept:
    - allow transactions to have a consistent view of the database at a particular point in time
    - each transaction reads from a snapshot of the database that is taken at the start of the transaction
    - other transactions can modify the database, but the current transaction will not see those changes
    - snapshot isolation is a boon for long-running, read-only queries such as backups and
    analytics
    - implemented by many popular databases, include Oracle, Microsoft SQL Server, PostgreSQL, and MySQL (with the InnoDB engine).
- Implementation
    - Write: use object locks to avoid concurrent updates from multiple uncommitted txns
    - Read: MVCC
        - readers never block writers, and writers never block readers
        - like read-comitted, DB needs to maintain multiple versions of the same object
        - When a transaction is started, it is given a unique, always-increasing transaction ID (txid).
        - Whenever a transaction writes anything to the database, the data it writes is tagged with the transaction ID of the writer.
        
        ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/76429233-9ea3-4958-bea5-cd26d1327ecb/Untitled.png)
        
        - Tombstone: If a transaction deletes a row, the row isn’t actually deleted from the database, but it is marked for deletion by setting the deleted_by field to the ID of the transaction that requested the deletion.
        - GC: At some later time, **when it is certain that no transaction can any longer access the deleted data**, a garbage collection process in the database removes any rows marked for deletion and frees their space.
    - MVCC Read Process (How to view a snaptshot)
        1. Ignore all changes made by running txns
        2. Ignore all changes made by aborted txns
        3. Ignore all changes made by txns with larger txn_id
        4. Then, all available values are visiable
