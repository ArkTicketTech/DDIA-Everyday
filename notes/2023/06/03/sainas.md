P79-P83

**Making an LSM-tree out of SSTables**

Log-Structured Merge-Tree (or LSM-Tree)
LSM-trees: keeping a cascade of SSTables  that are merged in the background

Full-text search engine use similar method: a term(a word) -> IDs of documents

**Performance Optimizations**

LSM-tree algorithm can be slow when looking up keys that do not exist
Solution: Bloom filters

Strategies to determine the order and timing of how SSTables are compacted and merged: *size-tiered* and *leveled compaction*

LSM-trees—keeping a cascade of SSTables that are merged in the background—is simple and efficient

- Even when the dataset is much bigger than the available memory
- Can range query
- Remarkably high write throughput, because the disk writes are sequential

#### B-Trees

log-structured indexes - *Segments*
B-trees - *fixed-size blocks or pages* (~4KB)

Each page can be identified use an address: like a pointer

*Leaf page* contains the value or references

The number of references to child pages in one page of the B-tree is called the *branching factor.* (typically several hundred)

Adding a new key: If there isn’t enough free space in the page to accommodate the new key, it is split into two half-full pages, and the parent page is updated too

This algorithm ensures that the tree remains *balanced*: `depth = O(log n) `

Most databases can fit into a B-tree that is three or four levels deep, so you don’t need to follow many page references to find the page

(A four-level tree of 4 KB pages with a branching factor of 500 can store up to 256 TB.)

(500^4)*4KB = 2500 *10^8 = 250TB

**Making B-trees reliable**

B-trees modify files in place

Problem 1: On SSD it must erase and rewrite fairely large block. Sometimes several pages (dangerous if crashes, corrupted index, orphan page)

Solution: write-ahead log (WAL, also known as a redo log): an append-only file

Problem 2: concurrency control

Solution: *latches* (lightweight locks)
Logstructured approaches are simpler in this regard, because they do all the merging in the background without interfering with incoming queries

**B-tree optimizations**

- Rather than WAL, some DB use copy-on-write scheme. Modified page written elsewhere, new version of parent page point to it (good for concurrency)
- Save space by not storing entire key, only abbriviation. (higher branching factor)
- "nearby key ranges to be nearby on disk" not required, but good for key range scan read. Many B-trees implement, but hard to maintain. LSM easiler to maintain since it rewrites during merge.
- Additional pointer: reference to sibling pages, also help scanning
- B-tree variants *"fractal trees"* borrow some log-structured ideas to reduce disk seeks
B-tree variants *"fractal trees"* borrow some log-structured ideas to reduce disk seeks

> fractal trees: a write-optimized data structure
>
> Why B-tree slow? Only part of the tree fit into memory. Every write need I/O to find the key
>
> B-trees node = pivot & pointer
>
> Fractal  node = pivot & pointer & **buffers**
>
> - in the root node, find out which child the write SHOULD traverse down
> - serialize the pending operation into the buffer
> - if the buffer associated with that child has space, **return**. If the node’s buffer has no space, **flush** the pending operations in the buffer down a level, thereby making space for future writes.
>
> Why is it faster? Reduced I/O. Do an I/O for not one row, but many rows
>
> Another interesting thing is if everything fits in memory, then Fractal Tree indexes are not providing any algorithmic advantage over B-Trees for write performance.
