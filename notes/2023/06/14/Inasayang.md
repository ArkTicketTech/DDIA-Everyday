动态分区

-   分区数据超过阙值，则拆分；反之，则合并
-   在第一个分裂点之前，所有读写都是单个节点
    -   允许空数据库配置初始分区（预分裂）



按节点比例分区

-   动态分区和固定数量分区中，分区数量与节点数无关
-   每个节点固定分区数量，分区大小与数据集成正比



请求路由

-   处理策略
    -   允许客户端连接任意节点
    -   客户端亲求发送到路由层
    -   客户端感知分区和节点分配关系



Pp. 200-208