### 故障切换有哪些要考虑的问题？

1. 如果开启了异步复制，旧Leader挂之前在自身写入了某个数据处于Index N，但是没能广播，而接任的新Leader在index N上也写入了自己的数据，就Leader作为Follower重新加入集群时，在N这个位置上就和新Leader冲突，**解决方法一般就是以当前Leader为准**。

   > 最常见的解决方案是简单丢弃老主库未复制的写入，这很可能打破客户对于数据持久性的期望。

2. 脑裂问题，比如发生网络分区，其中没有Leader那个分区选出了新Leader，那么对于客户端来说，就会有两个Leader了，分别接受不同客户的写操作，造成数据不一致。

### 数据怎么同步的？

一般来说是复制日志，日志中某一次的操作，Leader将收到的命令包装成日志发送出去，每个节点都保存着所有执行过的日志。

1. 某些非确定性的操作，比如写入一个Rand值，如果把他们分散到所有节点各自执行，那么得到的结果必然不同。
2. 对于某些操作要严格保证顺序，比如数据库的自增ID，节点不能把收到的操作暂存，然后乱序执行。

以上问题都是由于日志中存储的是某一条语句造成的，如果将日志中记录的粒度变小，比如基于行复制，每一个行变化的操作都作为单独的日志被复制，就能解决
