##### Handling skew
如果存在与单个键关联的大量数据，则 “将具有相同键的所有记录放到相同的位置” 这种模式就被破坏了。这种不成比例的活动数据库记录被称为 **关键对象（linchpin object）** 或 **热键（hot key）**。

一个 Reducer 必须比其他 Reducer 处理更多的记录。由于 MapReduce 作业只有在所有 Mapper 和 Reducer 都完成时才完成，所有后续作业必须等待最慢的 Reducer 才能启动。

如果连接的输入存在热键，可以使用一些算法进行补偿。例如，Pig 中的 **偏斜连接（skewed join）** 方法首先运行一个抽样作业（Sampling Job）来确定哪些键是热键。连接实际执行时，Mapper 会将热键的关联记录 **随机**（相对于传统 MapReduce 基于键散列的确定性方法）发送到几个 Reducer 之一。对于另外一侧的连接输入，与热键相关的记录需要被复制到 **所有** 处理该键的 Reducer 上。

这种技术将处理热键的工作分散到多个 Reducer 上，这样可以使其更好地并行化，代价是需要将连接另一侧的输入记录复制到多个 Reducer 上。 Crunch 中的 **分片连接（sharded join）** 方法与之类似，但需要显式指定热键而不是使用抽样作业。

Hive 的偏斜连接优化采取了另一种方法。它需要在表格元数据中显式指定热键，并将与这些键相关的记录单独存放，与其它文件分开。当在该表上执行连接时，对于热键，它会使用 Map 端连接。

当按照热键进行分组并聚合时，可以将分组分两个阶段进行。第一个 MapReduce 阶段将记录发送到随机 Reducer，以便每个 Reducer 只对热键的子集执行分组，为每个键输出一个更紧凑的中间聚合结果。然后第二个 MapReduce 作业将所有来自第一阶段 Reducer 的中间聚合结果合并为每个键一个值。