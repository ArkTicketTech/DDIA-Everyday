P209-P213
#事务
事务将多个应用程序的多个读、写操作捆绑在一起成为一个逻辑操作单元
简化了应用层的编程模型，
如何判断是否需要事务，
首先需要确定的了解事务能够提供哪些安全性保证，背后的代价是什么，
数据库防范的基本方法和算法设计，并发控制，各种竞争条件，隔离级别，读提交，快照隔离，可串行化。
深入理解事务
ACID
Atomicity 原子性
Consistency 一致性
Isolation 隔离性
Durability 持久性
不符合ACID标准的系统被冠以BASE
Basically Available 基本可用性
Soft state 软状态
Eventual consistency 最终一致性，
