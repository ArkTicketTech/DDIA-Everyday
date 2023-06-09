键值数据的分区

-   目的：数据和查询负载均匀分布各个节点上
-   倾斜：分区不均匀，导致分区效率下降
-   热点：负载严重不成比例的分区
    -   避免：随机分配到所有节点上
        -   缺点：查询需要查询所有节点
-   如果数据是键值数据模型，可以用关键字查找



基于关键字区间分区

-   为每个分区分配关键字区间范围
-   关键字的区间段不一定均匀分布，因为可能数据本身就不是均匀的
-   每个分区内按关键字排序保存（`SSTables`和`LSM-Tree`）
-   缺点：某些访问模式会导致热点
    -   如，数据按传感器写入，则所有写入都集中在同一个分区



基于关键字哈希值分区

-   许多分布式系统都采用
-   哈希函数不需要在加密方面很强
-   某些哈希函数不适合分区（如，`Java`的`Object.hashCode`，在不同进程中可能返回不同的值，还有这种操作？）
-   为每个分区分配一个哈希范围
-   分区边界可以是均匀间隔，也可以是伪随机选择（一致性哈希）（TODO）
-   缺点：区间查询可能要查询所有节点，或者不支持区间查询（那为什么许多分布式系统都采用？）
    -   Cassandra的复合主键由多个列组成，第一部分用于哈希分区，其余部分用作组合索引来进行排序（不支持第一列区间查询，但是可以对其他列区间查询）



负载倾斜与热点

-   极端情况：所有的读写都是同一个关键字
    -   如，一个有百万粉丝的名人账号突发热点事件
-   通过应用层解决倾斜程度
    -   关键字前或后添加随机数，查询数据后再合并
    -   只对少量热点关键字
    -   需要额外的元数据标记



Pp. 190-195