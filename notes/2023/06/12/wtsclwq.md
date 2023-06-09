在大多数系统中，都采用了异步复制，为什么呢？一个很重要的原因是异地分布的时候，同步带来的延迟可能是巨大的。

> 链式复制：Leader->Follower1->Follower2，有点像GFS写数据那样

### 新增Follower会发生什么？

直接从任意一个老人那里复制一份给新人是不够的，因为数据时不断在更新的，你在复制文件的时候，可能已经复制过来的文件刚刚被更新了却不知道。

直接停止某个节点，让其不再接受更新，直到复制结束，虽然结果是正确的，但是违背了分布式系统的高可用目标。

那么到底该怎么做呢？

1. 利用数据库自带的快照功能，每隔一段时间主机更新一次快照

2. 新节点获取到Leader的快照，当作自己的快照使用

3. 新节点和Leader通讯，从Leader那里接受上一次快照以来的所有数据变更，这样就能够减少潜在的错误。

   > 这要求快照与主库复制日志中的位置精确关联。该位置有不同的名称，例如 PostgreSQL 将其称为 **日志序列号（log sequence number，LSN）**，MySQL 将其称为 **二进制日志坐标（binlog coordinates）**。

4. 当新节点追上Leader之后，作为一个正常的成员参与集群的读写活动

### 有节点宕机了怎么办？

两种情况：

1. Follower宕机：如果是短暂的崩溃、重启、断联，可以通过日志轻松赶上。否则可以类似于新节点加入那样从0开始
2. Leader宕机：备胎上位，找一个Follower作为新Leader，接管客户端的请求，并且将自己的进度同步给其他Follower

### 
