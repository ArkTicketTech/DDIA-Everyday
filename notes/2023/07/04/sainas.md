P195-P209

## Chapter 6. Partitioning

Reason to partition: scalability

### Partitioning and Replication

Each node may be the leader for some partitions and a follower for other partitions

### Partitioning of Key-Value Data

To avoid skew and hotspot

Random assign: don't know where to read

#### Partitioning by Key Range

Boundaries choosing: manual or automatic
Sort each partition

Pros
can do range scan

Cons
hotspot. e.g. partition by timestamp, but all the writes happen to today's partition

To avoid: prefix 
Prefix the timestamp with a sensor name

#### Partitioning by Hash of Key

Hash function:
Doesn't have to be cryptographically strong
Programming language hash is not suitable: same key may have different hash

Boundaries choosing: evenly, or pseudorandomly (Consistent Hashing)

Con: can't do range query efficiently

Cassandra compromise
Compound primary key
First part of that key is hashed to determine the partition, but the other columns are used as a concatenated index for sorting
Query can not range query first part, but can do range scan if first part is fixed

e.g. (user_id, update_timestamp)  can query post of one user within some time interval

#### Skewed Workloads and Relieving Hot Spots

e.g. a celebrity news -> many writes of the same key

Hashing doesn't help

Solution:
Add a random number

But any read need to do additional work
Also need bookkeeping: only make sense to do this on small number of keys

### Partitioning and Secondary Indexes

Secondary index doesn't define value uniquely, just for searching

Secondary index

- bread and butter of relational db
- Many key-value store don't support (e.g. HBase)
  Some support (e.g. Riak)
- purpose of search servers (Solr, Elasticsearch)

Secondary indexes don’t map neatly to partitions

Two solutions:

-  document-based partitioning 
- term-based partitioning.

#### Partitioning Secondary Indexes by Document

e.g. selling cars, each has document ID

But want to allow user to search by make and color

DB partition maintains a secondary index:

color:red [document IDs]
color:blue [document IDs]
make:Audi [document IDs]

document-based partitioning 

AKA *local index*

Read from all partitions

AKA *scatter/gather*

It is prone to tail latency amplification

#### Partitioning Secondary Indexes by Term

Rather than *local index* Use *global index*

Partitioned global index (partitioned differently than PK)

Partition 1: color a to r, make a to r
Partition 2: color r to z, make r to z

One write may need to update several partition

Partition by

- the term
  can range scan
- hash of the term
  more even distribution of the load

Pros of global index:
read more efficient
Cons:
write slower

Ideal: index always up to date
Need distributed transaction across all partitions, some DB doesn't support
Reality: update to global indexes are often async

