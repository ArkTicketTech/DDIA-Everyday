P76-79

### SSTables and LSM-Trees
Sorted String Table
- Require that the sequence of key-value pairs is sorted by key
- each key only appears once within each merged segment file

Benefits:
1. Merging segments is simple and efficient (mergesort, doesn't have to fit in memory)
2. Find key is easier: index can be sparse
3. Can group and compress before writing into disk. Saving disk, reduce I/O bandwidth (since you need to scan several keys anyway due to 2)
    
**Constructing and maintaining SSTables**
How to get data sorted in the first place?
- Maintaining a sorted structure on disk is possible: B-Trees
- Maintaining a sorted structure in memory is easy: red-black tree, AVL tree

Steps
1. write to in-memory balanced tree (called _memtable_)
2. Bigger than threshold -> write to disk
3. Read: check memtable, then disk segment from latest to next older
4. Run a merging and compaction process in backgroung

One problem: DB crashes. Thus a separate append-only log
