# Map-side joins

Pros of reduce-side join: separation of responsibility:

- Mapper: preparing data: extracting key and value from each input record, assigning the kv pairs to a reducer partition, and sorting it by key.
- Reducer: read the partition and do calculation

but it can be expensive due to the data movement for reducer operations.

it would be better if we can minimize all the data movement to gain better perf

This is map-side join

- It requires certain assumptions about the input data
- cut down version of full MR job: no reducers involved and no sorting
- each mapper reads input file block from filesystem, process it, and write output kv pairs back to filesystem

## broadcast hash join

**Assumption**: size of one joining table is small enough to be loaded into mapper’s memory

Mappers build hash table using the smaller table and scan over the larger table and simply look up the hash table. 

If the smaller table cannot be loaded into memory, an alternative is to store it on the disk of every mapper node. We can build index on it and hope that page cache can reduce read time.

## partitioned hash join

In the case of broadcast hash join, if input tables are partitioned in the same way (with the same key range and same number of partitions), then we don’t need to load the whole smaller table. A mapper can just load the matched partitions with the same key ranges from input tables.

## map-side merge join

a further assumption on partitioned hash join:

the input tables are both **sorted** and **partitioned** based on the same key

then a mapper does not have to load the whole partition. it can read both input data tables incrementally, in order of ascending key, and matching records with same key.

this can further can memory usage, but may cause more disk reads.

Map-side join’s inputs are likely from other MR jobs.
