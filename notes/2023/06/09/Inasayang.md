`Quorum`一致性的局限性

-   必须保证成功写入的节点和读取的节点有交集
-   在w+r>n的情况下，也可能存在返回旧值的边界条件（？没懂，这种情况不是必然包含新值）
    -   使用sloppy quorum
    -   多个写操作，无法确定先后（如，根据时间戳，会因为时钟偏差问题，同一个DC会有这个问题吗？）
    -   读写同时发生，写只在一部分副本上完成，但是读取时，会有不确定性
    -   部分写成功，部分写失败，但是成功数小于失败数，成功的节点不做回滚，读取时还包括新值
    -   读取时，成功的节点失效，恢复时使用旧值
-   需要配合监控旧值



宽松的quorum和数据回传

-   网络中断，暂时接受写请求，写入临时节点（不在n节点集合中）
-   网络恢复，临时节点把写请求发送到原始节点（数据回传）
-   缺点
    -   读取时，可能还是旧值，因为还没回传过来

Pp. 171-175