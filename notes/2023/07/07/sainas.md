
P219-P227

## Chapter 7. Transactions

Why transaction?
Things can go wrong:

- db failed (software/hardware)
- app crashes
- Interrupted network
- Clients write concurrently
- Client read partially updated data
- Race conditions

*Transaction*: simplify the issue

What is transaction?
"a way for an application to group several reads and writes together into a logical unit" either all succeeded or fails
No partial failure

When to use transaction?
Sometimes abandon for higher performance / availability

#### The Slippery Concept of a Transaction

X Not true to say "transactions were the antithesis of scalability"

X Not true to say "transactional guarantees essential requirement for “serious applications” with “valuable data.”

both are hyperbole

##### The Meaning of ACID

Atomicity, Consistency, Isolation, and Durability.

But "isolation" is pretty ambiguous

**Atomicity**

Can mean different things

In multi-threaded programming:

- Another thread can not see the half-finished result of an atomic operation

In DB: not about concurrency

- Multiple writes, either committed, or aborted and undo

Ensure aborted transaction didn't change anything
Safe to retry

**Consistency**

It is terribly overloaded

- In replica: eventual consistency
- In partitioning: consistent hashing
- CAP: consistency means linearizability
- ACID: db "being in a good state"

Invariants are always satisfied
e.g. in accounting, credits and debits are balanced.
the db stays valid before and after the transaction

It's a property of the application

`C -> application`
`A I D -> database`
application needs to rely on db's ` A I` to achieve `C`

**Isolation**

About Concurrency and race condition

"Concurrently executing transactions are isolated from each other"

textbook formalized isolation as *serializability*

"Each transaction can pretend that it's the only transaction running on the entire DB. Result is the same as if they had run serially"

Serializable isolation is rarely used
Since it carries a performance penalty

Some weaker guarantees are used

**Durability**

"Once a transaction is committed, data will not be lost even a hardware fault or db crash"

Single-node DB: means written to nonvolatile storage (hard drive/SDD) and has write-ahead log for recovery

Replicated DB: means data has been copied to some number of nodes, then report transaction committed

Perfect durability doesn't exist: all disks are destroyed, nothing can save

Replication and durability

- Power outages: crash all nodes. All data in memory are lost. Thus we still want to write into disk for in-memory db
- Leader unavailable: async replica lost recent writes
- Hardware: 
  - bugs. SSD sometimes violates the guarantees if suddenly loses power
  - SSD bad block
  - SSD start losing data without power, depending on temperature
- Storage engine and filesystem bugs
- Data corrupted gradually, and so does replicas/recent backup. (Can be fixed by restoring historical backups)

