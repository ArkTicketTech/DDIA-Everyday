P188-P193
# 第六章数据分区
关于术语的澄清，MongoD吧，ES，solr，中是shard Hbase里面是region bitabel中是tablet，Cassandra riak中vnode
couchbase是vBucket
分区的方式
键-值数据的分区，
数据倾斜，会导致分区效率严重下降。避免系统热点的方式方法
1、随机分配
改进方式，关键字区间分区，类似于百科全书，分区边界的确定，分区在平生。
基于关键字哈希值分区，解决数据倾斜和热点问题。
