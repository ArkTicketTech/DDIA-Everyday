  # MapReduce and Distributed Filesystems

# input & output

distributed filesystem, e.g., HDFS (open source impl of GFS), Azure Blob Storage, AWS S3, …

shared nothing: also storage nodes are connected by network

- easy to scale
- cheap
- vs. SAN or NAS (shared disk storage, which uses special hardware)

HDFS: file blocks are replicated on multiple nodes to tolerate failures

# Job execution

Mapper: read input file from HDFS, generate any number of kv pairs, writes them to local files

Reducer: take kv paris produced from Mapper that belongs to the same key, calls the reducer to iterate over them, then output records.

## distributed execution

we can have multiple mappers and reducers, so as to increase processing throughput.

put the computation near the data: run computation jobs on the machine that store the data, instead of moving data to the computing nodes

- network bandwidth is not enough compared to data size
- we can ship computing logic (in JAR or Lib) to the storage node

that’s why mappers run directly on the HDFS nodes and write the output file to local disk (in case of non-EC involved scenario)

in Reduce phase, reducer has to pull data from difference sub-files to its local disk. This is called as shuffle, and network communication is unavoidable
