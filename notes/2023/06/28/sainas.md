P158-P162

#### Implementation of Replication Logs

##### 1. Statement-based replication

SQL statement

Cons:

- nondeterministic functions: NOW()  RAND()
- autoincrementing column, or depends on the data (UPDATE...WHERE...)
  Must be same order, but there could be concurrent transactions
- side effects: triggers, user-defined functions

Workaround: replace nondeterministic with fixed return
But still many edge cases

##### 2. Write-ahead log (WAL) shipping

Main disadvantage: log are very low level (which bytes were changed.)
If database storage format version changes, not possible
Follower and leader must be same version

Thus can't do zero-downtime upgrade

##### 3. Logical (row-based) log replication

Different log format for storage and replication  (Decoupling)

logical log (compared to physical data)

- Insert: new value
- Delete: info to uniquely define the row. PK if the table have one, otherwise values
- Update: uniquely defined row, and new values of (all or changed) column

Pros:

- Can be kept backward compatible within different version of software or even storage engine
- Easier for external app to parse (e.g. data warehouse, building custom indexes and cache)

##### 4. Trigger-based replication

1-3 are done by database system. No application code involved

More overhead, but more flexible

Many db have this functionality
*triggers and stored procedures*

A trigger lets you register custom application code that is automatically executed when a data change (write transaction) 



### Problems with Replication Lag

Leader-based replication:  Attractive for read heavy system

*read-scaling* architecture: many followers (BUT must be asynchronous)

But read from asyn follower would get out-dated info: temp inconsistency

When the followeres catch up: eventual consistency

