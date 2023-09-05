  # Comparing Hadoop to Distributed Databases

Hadoop contains HDFS + MapReduce

MPP database: well optimized, suitable for SQL.

However, not all calculation can be modeled by SQL (e.g., complex calculations, like ML, NLP, or even calculation topology graphs from traces)

Other the other hand, MapReduce is more flexible. You can define your own calculation logic (Hive UDF, user defined function / UDAF)

## Pros & Cons of MapReduce

Pros: Computation results are saved and can be safely retried in the face of failures

Cons: Performance of writing to disk is bad

MapReduce was good because in old resource scheduler MR jobs had low priority and could be killed if resource was tight. However, modern scheduler does not do that often.

# Beyond MapReduce

Since operators are a generalization of map and reduce, the same processing
code can run on either execution engine: workflows implemented in Pig,
Hive, or Cascading can be switched from MapReduce to Tez or Spark with a simple
configuration change, without modifying code
