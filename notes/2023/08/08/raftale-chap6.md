## 请求路由

由于数据存储在多个节点和分区，客户端如何知道哪个key在哪个分区哪个节点，再平衡后，发生变化的节点和分区信息如何被客户端知晓。

这类问题被称为为服务发现（service discovery），概括的来说，有几种不同的方案：

1. 每个节点都有全局路由表：允许客户联系任何节点，再由当前节点中的全局路由表路由到正确的节点；
2. 由一个专门的路由层来记录：路由层有所有信息，客户端所有请求都经过路由层转发；
3. 客户端自己知晓分区和节点的分配。

作为路由决策的组件，如上面的全局路由表、路由层、客户端，如何及时了解分区-节点之间的分配关系变化？
这是个很难的问题，要让节点都达成共识，但难在哪要看第九章才知道。
业界一般的做法：

1. 依赖外部协调组件：如ZooKeeper，来跟踪集群元数据， 每个节点在 ZooKeeper 中注册自己，ZooKeeper 维护分区到节点的可靠映射。 其他参与者（如路由层或分区感知客户端）可以在 ZooKeeper 中订阅此信息。 只要分区分配发生了改变，或者集群中添加或删除了一个节点，ZooKeeper 就会通知路由层使路由信息保持最新状态。
2. 使用某种协议点对点同步：Cassandra 和 Riak 采取不同的方法：他们在节点之间使用 **流言协议（gossip protocol）** 来传播集群状态的变化，免除了对外部协调服务的依赖。



## 本章总结

分区的意义是，数据文件本身过大的情况下，会出现负载过大导致的性能问题。

分区的目标是将数据在物理层面分摊到不同的节点上。

既然要分区，就会面临如下问题：

1. 分区的策略，是直接基于key的范围分区，还是基于hash(key)的范围分区，前者支持高效的范围查询，但可能出现热点问题，后者对key负载均衡，但不支持范围查询
2. 不管哪种分区策略，当业务始终针对一个key操作时，还是会可能有热点数据问题，业务层需要慎重考虑设计；
3. 不止是数据分区，二级索引又该如何分区？
   1. 每个分区维护本分区的二级索引；
   2. 每个分区维护所有分区的二级索引；
4. 既然是分布式系统，不可避免涉及到节点水平上的扩容 或是节点之间的故障切换，数据和分区也需要跟着节点进行再平衡。
   1. 再平衡不能影响节点的负载均衡，要保证不下线正常业务，再平衡的开销要尽可能小；
   2. 再平衡的策略有，这些策略都在尽可能的减少再平衡的开销等，促使再平衡的稳定和高效：
      1. 固定数量的分区：分区的大小与数据集大小成正比；
      2. 动态分区：分区的数量与数据集大小成正比
      3. 与节点成比例分区：分区的数量与节点数量成正比
5. 既然是分布式系统，同样不可避免需要节点和分区的路由表，路由表相当于系统的地图，了解哪些数据在哪些节点的哪些分区。
   1. 这类问题概况称为服务发现，
   2. 路由表记在哪个地方？可以记录在每个节点中，也可以再单独开一个路由层专门做记录，还可以与客户端约定俗成硬编码
   3. 还有如何准确可靠的记录这张路由表成为了最重要的问题。
      1. 涉及到节点间记录表时如何达成共识。为什么会有这个问题，假设节点不可靠或存在欺骗？要看第九章

