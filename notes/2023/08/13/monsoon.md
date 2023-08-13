- SSD internally uses a log-structured algorithm to write sequentially
 - lower write amplification and reduced fragmentation are still useful

 #### Downsides of LSM-trees
 - unpredictable compaction interference
 - compaction rates should keep up with write throughput, or storage will be all consumed
 - each key exsits exactly once in b-tree, but multiple copies in LSM tree (locks for tranx)

 ### Other Indexing Structures
 - value can be stored elsewhere (index: key->value or key->reference to value)
 - heap file is where we keep all the actual data
 - update a value without changing the key: if not larger, just overwrite; if larger, move to a new space and update indexes/add a forwarding pointer
