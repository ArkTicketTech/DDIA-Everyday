配置新从节点

-   主节点上数据副本生产一致性快照
-   拷贝快照到从节点
-   请求快照之后的数据更改日志并应用



处理失效节点

-   从节点失效：追赶式恢复
-   主节点失效：切换节点
    -   如果使用异步复制，原主节点丢弃未完成复制的写请求
    -   脑裂：两个节点都认为自己是主节点（多主节点复制技术）



复制日志的实现

-   基于语句复制（从节点执行每条从主节点发来的操作语句）
    -   非确定性函数（`NOW()`）会产生不同的值
    -   自增列
    -   副作用的语句（触发器，存储过程等）产生不同的作用（？不是很清楚）

基于WAL

-   复制方案和存储引擎紧密耦合，如果存储格式改变，通常无法支持运行不同的版本
-   复制协议要求版本严格一致



基于行的逻辑日志复制

-   复制和存储引擎使用不同的日志格式
-   复制日志为逻辑日志
    -   插入，日志包含相关列的新值
    -   删除，有足够的信息标识行，如果没有主键，则需要所有列的旧值
    -   跟新，有足够的信息标识行以及所有已更新列的新值
-   逻辑日志与存储引擎逻辑解耦，支持运行不同的版本或存储引擎



基于触发器的复制

-   复制控制由应用程序层完成
-   开销高，也更容易出错，但是灵活性高





Pp. 148-154