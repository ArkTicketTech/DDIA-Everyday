### SSTables and LSM-Trees
- Sorted String Table (SSTable): kv pairs sorted by key
- each key only appear once within each merged segment file (Compaction ensures this)
- one segment contains contiguous records, so just discard the values from older segment if we encounter same key
- in-mem index can be sparse, so that read need to scan over several records
- group those records into a block and compress to save disk space and reduce I/O

#### Constructing and maintaining SSTables
- many in-mem data structures (RB tree/AVL tree) to support write in any order and read in sorted order
- storage engine workflow
  * add writes to the in-mem balanced tree data structure (memtable)
  * memtable bigger than some threshold: write it out to disk as an SSTable file (most recent segment)
  * writes continue to a new memtable instance
  * for reads: find the key in the memtable
  * then search it in the latest SSTable, and so on
  * merging and compaction from time to time in background
- one problem: memtable has no durability. solution: separate unordered log in disk

#### Making an LSM-tree out of SSTables
- LevelDB and RocksDB, both inspired by BigTable
- Log-Structured Merge-Tree (LSM-Tree)
