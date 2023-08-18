#### Performance Optimizations
 - Bloom filters: filter non-existent keys, which would be expensive to check
 - when to compact and merge: size-tiered or leveled compaction
 - basic idea: keep a cascade of SSTables and merge in the background
 - efficient range queries due to sorted keys and high write throughput due to sequential writes

 ### B-Trees
 - sorted kv pairs
 - LSM tree (variable-size segments) vs B-tree (fixed-sized blocks)
   * why? corresponds to underlying hardware
 - page can be referred using an address (pointer on disk)
 - one page as root (keys + refs)
 - leaf nodes point to a continous range of keys, keys between the ref indicates the boundary
 - *branching factor*: number of refs to child pages
 - if not enough space when adding keys, split into two, add another key in parent
