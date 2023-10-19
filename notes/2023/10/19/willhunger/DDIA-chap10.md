#### Comparing Hadoop to Distributed Databases
MapReduce 中的处理和并行连接算法，早已在 MPP 数据库上实现过了。
两者最大的区别是，MPP 数据库专注于在一组机器上并行执行分析 SQL 查询，而 MapReduce 和分布式文件系统的组合则更像是一个可以运行任意程序的通用操作系统。

##### Diversity of storage
数据库要求你根据特定的模型（例如关系或文档）来构造数据，而分布式文件系统中的文件只是字节序列，可以使用任何数据模型和编码来编写。

##### Diversity of processing models
MPP 数据库是单体的，紧密集成的软件，负责磁盘上的存储布局，查询计划，调度和执行。由于这些组件都可以针对数据库的特定需求进行调整和优化，因此整个系统可以在其设计针对的查询类型上取得非常好的性能。但是某些方面的处理并不适合用 SQL。

MapReduce 相关系统不仅可以使用 MapReduce，也可以使用 SQL。

Hadoop 生态系统包括随机访问的 OLTP 数据库，如 HBase 和 MPP 风格的分析型数据库，如 Impala 。 HBase 与 Impala 都不使用 MapReduce，但都使用 HDFS 进行存储。它们是迥异的数据访问与处理方法，但是它们可以共存，并被集成到同一个系统中。