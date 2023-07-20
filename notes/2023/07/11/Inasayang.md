主从复制与共识 

Epoch和Quorum

-   协议中定义了一个世代编号-epoch number（对应于Paxos中的ballot number，VSP中的view number，Raft中的term number），保证在每个世代中，主节点是唯一的
-   当前主节点失效，开始投票选举新主节点，epoch号递增。拥有更高epoch号码的主节点获胜
-   从quorum节点收集投票



共识的局限性

-   达成一致性前，节点投票的过程是同步复制的过程
    -   通常配置为异步复制，存在丢失风险，只是为了更好的性能
-   需要严格的多数节点才能运行
    -   至少三个节点容忍一个
    -   至少五个节点容忍两个
-   依靠超时机制检测节点失效
    -   跨区域分布的系统，网络延迟高度不确定，导致误判
-   对网络问题特别敏感
    -   Raft存在不合理的边界条件处理
        -   网络中存在某条网络连接持续不可靠，会进入奇怪的状态，不断在两个节点之间反复切换主节点



成员与协调服务

-   zookeeper和etcd保存少量，可完全载入内存的数据
-   采用容错的全序广播算法



Pp. 344-361