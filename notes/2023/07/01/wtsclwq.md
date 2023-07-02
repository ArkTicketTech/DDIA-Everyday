### 动态分区

上面方式需要从一开始就确定分区的边界和数量，不太适合基于range的分区，因为数据不可能是均匀的插入和删除的，必然会导致不平衡，因此我们需要动态分区。

也就是可以Split和Merge

1. 初始化1个分区
2. 增加则分裂（按照key）
3. 减少则合并（相邻分区）

最近在做的tinykv就是这种方式

## 请求路由

我们想把负载分担到不同的节点上，那么一条请求改如何准确的找到目标节点呢？我们不能要求客户端去做这种事情。

**服务发现**的几种方式：

1. 在每个节点内维护路由表，客户端可以请求集群中的所有节点，如果正好是目标分区，就对其服务，否则转发
2. 实现一个路由层，所有的请求都发给它，再由路由层转发给目标节点。
3. 客户端自己维护

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/fig6-7.png" alt="img" style="zoom:50%;" />

**问题**：作出路由决策的组件（可能是节点之一，还是路由层或客户端）如何了解分区 - 节点之间的分配关系变化？

解决：

1. 依赖外部组件：Etcd、Zookeeper

​	<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/ch06-fig08.png" alt="zookeeper partitions" style="zoom: 25%;" />

2. 自己实现meta服务，三个节点实现raft即可
3. 节点之间点对点同步，比如redis使用的gossip

