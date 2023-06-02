#### 构建和维护SSTable

虽然可以直接从disk中构建有序的数据结构，但是在内存中构建显然更加高效，例如红黑树/AVL树/跳表。

基于如下步骤构建SSTable文件：

1. 在内存中维护一个有序结构（称为 **MemTable**）。红黑树、AVL 树、跳表。
2. 到达一定阈值之后全量 dump 到外存,dump期间的新写入就直接放在新的内存结构中

处理读取请求：

1. 先去 MemTable 中查找，如果命中则返回。
2. 再去 SSTable 按时间顺序由新到旧逐一查找。

维护SSTable文件：

- 如果 SSTable 文件越来越多，则查找代价会越来越大。因此需要将多个 SSTable 文件合并，以减少文件数量，同时进行 GC，我们称之为**紧缩**（ Compaction）。

容错：

- 如果数据库崩溃, 最近的写入(在内存表中但尚未写入磁盘)将会丢失

- 解决方案：WAL

#### 性能优化

1. **优化 SSTable 的查找**。常用 [**Bloom Filter**](https://www.qtmuniao.com/2020/11/18/leveldb-data-structures-bloom-filter/)。该数据结构可以使用较少的内存为每个 SSTable 做一些指纹，起到一些初筛的作用。

2. **层级化组织 SSTable**。以控制 Compaction 的顺序和时间。常见的有 size-tiered 和 leveled compaction。LevelDB 便是支持后者而得名。前者比较简单粗暴，后者性能更好，也因此更为常见。

3. RocksDB中有非常多的优化细节：
   1. Column Family
   2. 前缀压缩和过滤
   3. 键值分离，BlobDB
   4. ......

但无论有多少变种和优化，LSM-Tree 的核心思想——**保存一组合理组织、后台合并的 SSTables** ——简约而强大。可以方便的进行范围遍历，可以变大量随机为少量顺序。

