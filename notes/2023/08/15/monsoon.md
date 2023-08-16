- B-tree is guaranteed to be balanced (n key, depth = O(log n))
 - most db has 3-4 levels of B-tree (4-level, 4K page, branching factor 500 -> 256 TB storage)

 #### Making B-trees reliable
 - Write-ahead log (WAL, redo log) for fault-tolerance
   * append-only
   * every b-tree modification must be written before it can be applied
   * use log to restore after crash
 - concurrency control
   * latches (lightweight locks) to protect the tree

 #### B-tree optimizations
 * Copy-on-write instead of overwriting pages + WAL (LMDB)
 * save abbreviated keys
 * make the leaft pages in sequential order
 * additional pointers (leaf pages have pointers to siblings)

 ### Comparing B-Trees and LSM-Trees
 - LSM trees are optimized for writes, and B-trees are thought to be faster on reads

 #### Advantages of LSM-trees
 - B-tree: write at least twice (WAL + write itself, maybe even three times) and update the whole page at a time (page granularity?)
 - LSM-tree may also rewrite data multiple times (write amplification), SSDs don't like this
 - LSM typically has higher write tput: 
   * lower write amplification (depends on storage engine configuration and workload)
   * sequentialy writes (B tree has to overwrite several pages)
 - LSM has lower space usage (B tree has more fragamentation)
