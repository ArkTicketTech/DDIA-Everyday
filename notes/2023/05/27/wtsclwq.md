set就是在文件末尾追加一个对kv，get则是从后到前遍历整个文件，查找最新的一个kv的value

> 写很快，但是读需要全文逐行扫描，会慢很多。典型的以读换写。

为了能加快读取的速度，不得不建立索引，但是建立索引之后必然需要维护，每次插入都维护索引就会拖慢写入的速度，并且需要额外的空间存储索引。

> 重新以空间和写换读取

1. 恰当的**存储格式**能加快写（日志结构），但是会让读取很慢；也可以加快读（查找树、B 族树），但会让写入较慢。
2. 为了弥补读性能，可以构建索引。但是会牺牲写入性能和耗费额外空间。

### Hash索引

很多编程语言中的map基本都是kv存储，可以看作是一个简单的内存数据库，其数据结构基本都是hash table。
我们可以基于hash table为上一节的数据库建立如下索引：

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/image-20230528111237636.png" alt="image-20230528111237636" style="zoom:33%;" />

hash table中存储的内容：

1. Key 是查询 所用的Key
2. Value 是 KV 条目的起始位置和长度。

> 这听起来可能过于简单, 但它的确是 一 个可行的方法。 事实上, 这就是Bitcask (Riak中的默认存储引擎)所采用的核心做法
>
> Bitcask可以提供高性能的读和写, 只要所有的key可以放入内存(因为hash map需要保存在内存中)。 而value数据量则可以超过内存大小, 只需一 次磁盘寻址, 就可以将value从磁盘加载到内存。

> 如果你的 key 集合很小（意味着能全放内存），但是每个 key 更新很频繁，那么 Bitcask 便是你的菜。举个栗子：频繁更新的视频播放量，key 是视频 url，value 是视频播放量。

#### 压缩

如果不停的向一个文件中添加kv,那么文件的尺寸就会无限膨胀，但其实文件中有很多重复的kv，因为修改操作其实也是追加操作。因此可以对文件进行压缩，只保留最新的数据。

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/image-20230528112404016.png" alt="image-20230528112404016" style="zoom:33%;" />

这种压缩方式会使得文件暂时不可用，想要获得更高的可用性，可以分段压缩，从后向前，保留新追加kv的可用性，将比较早的数据分段压缩然后合并。

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/image-20230528112535326.png" alt="image-20230528112535326" style="zoom:33%;" />

