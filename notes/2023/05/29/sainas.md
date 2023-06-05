P71-P76

#### Hash Indexes

| --              | Design                                                       | How to query                                                 | Advantage                                                    | Limitation              | Use Case                                                     |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------- | ------------------------------------------------------------ |
| Simplist        | A hashmap in memory for offset of the data (Bitcask uses this) | find key in memory                                           | Quick look up                                                | All keys fit in the RAM | e.g. key is URL of video, value is number of time. Large write per key, not too many keys |
| With compaction | Break the log into segments, then compact (throw away duplicate keys, keep latest) | One hash map for each segment. Search key in map starting from the most recent segment | Can merge several segments. Can be done in a background thread, while serve read/write using old, then switch |                         |                                                              |

Improvements

- File format
  cvs not good. `<length of string in binary> + raw string` no need to escape
- Deleting records
  append a deletion record: tombstone
- Crash recovery: in-memory hash maps lost
  Too slow to rebuild map from segments. Store a snapshot of each hash map on disk
- Partially written record
  Detect with Checksums
- Concurrency control
  Common way: have only one writer thread.

**Append-only log Pros and Cons**

| Pros                                                         | Cons                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Appending, segment merging are **sequential write operations**. **Faster** especially on magnetic spinning-disk hard drives. (Also preferable on SSD) | **Large key not good**. Difficult to make an on-disk hash map perform well |
| **Concurrency and crash recovery** are much **simpler** since segment files are append-only or immutable. (file would not contain old and new value spliced together) | **Range queries are not efficient.** For e.g. Cannot easily scan over all keys between kitty00000 and kitty99999 |
| Merging old segments **avoids** the problem of **data files getting fragmented** over time |                                                              |

#### SSTables and LSM-Trees

