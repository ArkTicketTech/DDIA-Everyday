## BTree

BTree于1970年就被提出，仍是在目前在关系型数据库中最为流行的数据索引实现。

和LSM-Tree一样支持高效的点查和范围查询

其数据组织形式和LSM-Tree不同

- 以固定大小的页（page）或块（block，4k大小）来组织数据，每次读取或者写入一个页
- 页可以通过地址标识，彼此之间可以通过类似指针的方式互相引用
- B树的根是其中一个页面，每次查询都会从根页面开始进行。

![img](https://cdn.nlark.com/yuque/0/2023/png/32473878/1690205921165-268ef8c5-2913-4f69-b093-13f2601dc0a4.png)



B树的一个页面对子页面的引用（ref）的数量称为分支因子（branching factor)，上图分支因子为6。实际中，分支因子的大小取决于存储页面引用和范围边界所需的空间，这个值通常是几百。

ref指向另一个页，上图是一个具体的查询例子，我们每次读入每一页至内存中后，可以通过二分查找快速找到目标元组可能所在的叶子结点的路径。不断二分，最终我们会达到叶子结点，要么命中，要么说明数据不在这个Btree中。

![img](https://cdn.nlark.com/yuque/0/2023/png/32473878/1690206489901-a9f0a9e1-2de0-411b-8621-2fed4fe2b3af.png)

上图是一个具体的插入例子，首先我们也要先查询到目标key所在页面，找到的话在原地更新即可，否则需要在当前页面插入数据，然后将页面整体返回。

- 每一个页面都有一个阈值，如果包含的key超过这个阈值则会将当前页面分裂为两个页面，并在上层页中继续插入新的页面的引用；这个过程可能会级联发生，小于某个阈值也会产生级联合并的操作。

每个操作的ref数被称为branching factor；通常在数百个。整体查询时间复杂度与树高度有关，由于btree很好的维护了树的平衡性，对于有n个key的b-tree来说，时间复杂度为O(logN)

A four-level tree of 4KB pages with a branching factor of 500 can store up to 256 TB



### making Btree reliable

由于会原地修改数据，并且可能会由于分裂合并操作调整树的结构，需要引入预写日志，保证数据安全性。

并发控制也是一个非常复杂的问题。



### BTree optimization

copy-on-write 代替WAL

非叶子结点仅仅保留路由信息，而不存储数据

尽可能使得相邻叶子结点在**物理存储**上连续

叶子节点见增加兄弟结点的指针，遍历查询时效率更高

fractal tree借鉴了一些LSM-tree的思想



### Comparing B-Trees and LSM-Trees

最主要的差异在于B-Tree读取更快，LSM-Tree写入更快。时序数据库的场景下，LSM-Tree经常是一个更好的选择。

除次之外：

- LSM-Tree的优势：

- - 对于B-Tree来说写入是以页为单位的，因此即使只有一个元素变动，也需要写入整个页面
- LSM-Tree通常来说有更小的写放大，B-Tree更改数据时对页面可能有多次覆盖
- 顺序写吞吐更大
- 数据更紧凑，更适合压缩，相比于B-Tree有更小的磁盘碎片产生

- LSM-Tree的劣势：

- - 压缩进程可能会干扰当前的读写进程，导致性能不稳定
- 配置压缩是很重要的，否则可能导致压缩的速度跟不上写入的速度，从而导致磁盘耗尽和读取速度变慢
- LSM-Tree实现事务语义更为困难





### Other Indexing Structures

在关系型模型中我们除了有类似于前述针对key-value索引的主键索引，还有二级索引，即，关系表中在非主键索引属性到该表的索引。

- 通常包括：

- - 聚簇索引和非聚簇索引

- - - 聚簇索引，叶子结点存储数据本身；非聚簇索引，叶子节点存储主键的数据引用
- covering indx or index with included columns

- - 多列索引

- - - 一种实现方式是将二维地址通过space-filling curve转化成一维，然后用普通索引存储
- 更常见的是用专门的数据结构比如R树进行索引，POstGIS就是一种R树的实现

- 全文索引：

- - 这里的全文索引是指full-text的精确查询
- 前面提到lucene使用了类似LSM-Tree的存储结构存储term到postlist的映射；其内存中的索引结构是FST，类似于Trie树。
- [https://github.com/wfnuser/Algorithms/tree/main/Data%20Structures/FST/c%2B%2B](https://github.com/wfnuser/Algorithms/tree/main/Data Structures/FST/c%2B%2B)
- https://blog.burntsushi.net/transducers/#fst-construction

- 纯内存数据库

- - 使用NVM的存储引擎是目前研究的热点
