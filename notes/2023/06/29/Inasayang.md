进程暂停

-   分布式使用时钟的案例
    -   每个分区只有一个主节点，只有主节点可以接受写入，如何知道主节点没有失效
    -   主节点从其他节点获得租约（超时的锁）的方式，节点到期之前必须跟更新租约
    -   如果依赖于同步时钟，则有可能有几秒的差异
    -   `GC`语言中的`STW`等等

调整垃圾回收的影响

-   把STW视为一个计划内的临时离线
-   节点启动GC时，通知其他节点接管客户端的请求（延迟敏感的系统。。。）



Pp. 278-283