## KV数据的分区

我们的理想目标是均分，也就是数据和负载都能够均匀的分布在每一个分区上。

如果数据分区不公平，导致某些分区的数据或者负载更多，称之为**偏斜**。

偏斜会导致效率下降，不均衡导致高负载的分区称为**热点**。

### range分区

为每个分区指定一块连续的key范围，比如[1,10)一个分区，[20,30)一个分区。

但是这样也是有可能不均衡的，比如书的编号，可能有的T、U这种编号的书要比A、B开头的书多好几倍。分区的范围可以人工指定也可以自动分配。

分区内可以做排序，这样非常适合做范围扫描。

缺点是会导致热点问题，比如按照时间戳做key，对于一些时序数据，每天访问的节点都是当天的热点，其他节点则处于空闲状态。

>  为了避免传感器数据库中的这个问题，需要使用除了时间戳以外的其他东西作为主键的第一个部分。 例如，可以在每个时间戳前添加传感器名称，这样会首先按传感器名称，然后按时间进行分区。

### Hash分区

一个好的Hash函数能够充分保证均匀分布，并且我们不需要考虑加密问题

>  一致性哈希：会考虑逻辑分片和物理拓扑，将数据和物理节点按同样的哈希函数进行哈希，来决定如何将哈希分片路由到不同机器上

如果使用一致性哈希，我们就不用在内存中维护range到物理节点的映射了

Hash分区虽然更容易均衡，但是失去了便捷的范围扫描能力。

### 热点消除

> Hash分区不能完全避免热点问题：在极端情况下，所有的读写操作都是针对同一个key，所有的请求都会被路由到同一个分区。

什么时候会发生这种极端情况？比如网上突然爆出了大瓜，那么该明星的数据就会被同时大量读写

怎么解决这种热点问题？拼接主键，对热点数据的主键做一些拼接处理，比如加上2位十进制的后缀，一条主键就能分身成100条，当然这样也会在读写时增加额外的工作。
