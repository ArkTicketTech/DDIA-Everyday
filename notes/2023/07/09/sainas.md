P227-230

##### Single-Object and Multi-Object Operations

Atomicity: no partial failure
Isolation: concurrent transactions don't interfere

multi-object transactions:

- dirty read
  e.g. new email come in, in the mean time, the unread need to add 1. Another transaction read in between

Need way to determining which read and write are the same transaction

- Client TCP connection      BEGIN TRANSACTION and COMMIT
  (Not ideal since TCP connection can be interrupt)
- transaction manager can group operations by a unique transaction identifier

Many nonrelational database don't have such grouping (even *multi-put* can update several key's, not transaction semantics)

**Single-object writes**

Maintaining atomicity and isolation when write single object, even

- network interrupted
- power fails
- Other client read while writing

Storage engines mostly aim to provide it

- Atomicity: WAL for crash recovery
- Isolation: lock on each object

More conplex atomic operation

- increment operation 
  (replace read-modify-write cycle in prev example of new unread email)
- compare-and-set

But this is not "transaction" (miscalled for marketing purposes)
Transaction is about grouping multiple operations on multiple objects
