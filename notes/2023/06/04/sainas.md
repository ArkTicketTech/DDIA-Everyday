P83-P90

#### Comparing B-Trees and LSM-Trees

B-Tree:      Faster read    slower write
LSM-Tree: Faster write   slower read

However, benchmarks are often inconclusive and sensitive to details of the workload

**Detailed Comparison**

***write amplification***

B-tree

- write at least twice: to WAL and page (if pages are split write +1)
- write entire page even small change

LSM

- Also rewrite multiple time due to compaction and merging

Particular concern on SSDs (only limited number of writes before wearing out)

**Pros of LSM**

1. lower write amplification (usually)

   B-tree may overwrite several pages. LSM can do sequentially write (specially good for magnetic hard drive)

2. reduced fragmentation
   B-tree fragmentation. LSM removes fragmentation in compaction, lower storage overhead

3. On SSD: many SSD can turn random writes to sequential writes. But 1 + 2 allows more read and write within same I/O bandwith

**Cons of LSM**

1. Compaction can interfere with performance
   Response time mostly small, but at higher percentiles very high. B-trees: more predictable

2. Sharing write bandwidth

   The bigger the DB is, the more disk bandwidth is required for compaction

   Compaction can not keep up with incoming write, many segments, causing 1. disk full 2. slow read

3. Transaction isolation and lock

   B-tree: key exists in one place
   LSM: key exists in multiple files
   Transaction isolation is implemented using locks on ranges of keys
   In a B-tree index, those locks can be directly attached to the tree

#### Other Indexing Structures

secondary indexes: good for join
key are not unique:
Solution 1: key -> [list of row identifiers]
Solution 2: making key unique by appending a row identifier

**Storing values within the index**

Value can be actual row or reference to elsewhere (***heap file***)

1. Only references ***"Nonclustered index"***

  Heap file: Avoids duplicating data when multiple secondary indexes are present
  Update value: If new value is larger and need to move to another place: need to update all index, or forward pointer

2. Row directly within an index **"Clustered index"**
   Read performance better

Between clustered and nonclustered: A compromise: "covering index" / "index with included columns". Can "cover" some of the queries

More duplication -> faster read, overhead on write, addtional effort for transactional guarantees

**Multi-column indexes**

*"concatenated index"*

One usecase: geospatial

```sql
SELECT * FROM restaurants WHERE latitude > 51.4946 AND latitude < 51.5079 AND longitude > -0.1162 AND longitude < -0.1004;
```

A standard B-tree or LSM-tree index is not able to answer that kind of query efficiently

Alternatives

- Translate into a single number using a space-filling curve and then B-tree index
- Use R-trees

Another usecase: RGB Color (red, green, blue) e.g. on an ecommerce website search products by color

**Full-text search and fuzzy indexes**

similar keys,  grammatical variations

Lucene: search text for words within a certain edit distance 

(edit distance of 1 means added/removed/replaced)
SSTable-like term dictionary
Need search within an offset in the sorted file

Index is not sparse, but a finite state automaton over the characters in the keys, similar to a trie. 

Levenshtein automaton

**Keeping everything in memory**

We use disk because 1. durable (contents are not lost if the power is off), and 2. cheaper than RAM

As RAM becomes cheaper, the cost-per-gigabyte argument is eroded.

*inmemory databases*

- acceptable for data to be lost (e.g. *Memcached*)
- achieve durability: special hardware, write log to disk, snapshot to disk, replica 
- Weak durability by writing to disk asynchronously (e.g. Redis)

Counterintuitively, the performance advantage of in-memory databases is not "no read from disk" (Even a disk-based storage engine may never need to read from disk if you have enough memory)
They can be faster because no **overheads of encoding** data for writting to disk

Support more data models. e.g. Redis offers a database-like interface to priority queues and sets

Support datasets larger than memory. 
*"anti-caching approach"* Evicting the least recently used data from memory to disk, and loading it back into memory (still requires indexes to fit entirely in memory)
Similar to what operating systems do with virtual memory and swap files, but the database can manage memory more efficiently, smaller granularity of individual records rather than entire memory pages

Storage engine design may change if non-volatile memory (NVM) technologies become more widely adopted 
