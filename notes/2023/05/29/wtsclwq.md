#### SSTable的优点

1. 合并段更加简单高效, 即使文件大于可用内存，使用外部归并排，但是怎么处理相同的key呢？也就是说一个key有多个新旧不同的value，在普通的apend-only日志可以简单的自后向前遍历，那么如果我们要排序该怎么办？

   因为在合并之前，一个段包含的是某段时间内写入数据库的所有值，这也就意味着一个段中的所有值肯定比其他段中的所有值更新。那么我们合并多个段时，面对两个段中的同一个key,只要保留最新段中的value即可

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/image-20230530114018637.png" alt="image-20230530114018637" style="zoom:33%;" />

2. 在文件中查找特定的key时, 不再需要在内存中保存所有key的索引。 仅需要记录下每个文件界限（以区间表示：[startKey, endKey]，当然实际会记录的更细）即可。查找某个 Key 时，去所有包含该 Key 的区间对应的文件二分查找即可。

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/image-20230530114932236.png" alt="image-20230530114932236" style="zoom:33%;" />

3. **分块压缩，节省空间，减少 IO**。相邻 Key 共享前缀，既然每次都要批量取，那正好一组 key batch 到一块，称为 block，且只记录 block 的索引。

