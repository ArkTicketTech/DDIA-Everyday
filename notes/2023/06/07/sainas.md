P95-P99

### Column-Oriented Storage

Problem: fact table are too wide, even with index it still need to load full row in memory, but only a few columns  are needed.

Solution: Store all the values from each column in a separate file
Then a query only needs to read and parse those columns that are used in that query

#### Column Compression

Column-Oriented is easy to compress

*bitmap encoding*

Often, the number of distinct values **n** in a column is small compared to the number of rows

Small n: (like country code) bitmaps can be stored with one bit per row
Larger n:  run-length encoded to avoid too many zeros in the bitmaps.

Bitmap indexes can also help with certain queries, since bitwise operation is efficient

**Column families** 
Cassandra and HBase have a concept of *column families*, but still *row-oriented*
Within each column family, they store all columns from a row together, along with a row key, and they do not use column compression

**Memory bandwidth and vectorized processing**

Big data processing bottlenecks

1. bandwidth for getting data from disk into memory
2. bandwidth from main memory into the CPU cache
   - avoiding branch mispredictions and bubbles
   - making use of single-instruction-multi-data (SIMD) instructions in modern CPUs 

Column-oriented storage is also good for making efficient use of CPU cycles.

e.g.

1. Query engine can iterate through column data in a tight loop (that is, with no function calls). A CPU can execute such a loop much faster than code that requires a lot of function calls 
2. Column compression allows more rows from a column to fit in the CPU cache.
3. *Vectorized processing*: Bitwise operators can be designed to operate on such chunks of compressed column data directly
