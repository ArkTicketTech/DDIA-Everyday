#### Implementing Linearizable Systems
实现可线性化的系统，最简单的方案：只用一个数据副本。但无法容错：如果仅有的副本所在的节点发生故障， 就会导致数据丢失。

* 主从复制（部分支持可线性化）：如果仅主节点负责数据写入，其他节点维护数据的备份副本，则满足可线性化。
* 共识算法（可线性化）
* 多主复制（不可线性化）：具有多主节点复制的系统通常无法线性化的， 主要由于它们同时在多个节点上执行并发写入， 并将数据异步复制到其他节点。 因此它们可能会产生冲突的写入，需要额外的冲突方案，冲突时由多副本引入的。
* 无主复制（可能不线性化）：例如 quorum 配置，取决于如何定义强一致性。