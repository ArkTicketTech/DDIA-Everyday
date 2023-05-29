`SSTables`和`LSM-Tree`

-   `SSTables`（排序字符串表）。每个键在每个合并的段上只出现一次。
    -   段更高效
    -   稀疏索引
-   日志结构的合并树（`Log-Structured Merge-Tree`）
    -   查找不存在的键，要添加布隆过滤器
    -   大小分级：新的和小的`SSTables`被合并到旧的大的`SSTables`
    -   分层压缩：分裂多个小的`SSTables`



`B-trees`

-   保留按键排序的键值对
-   将数据库分成块或页
-   新数据覆盖旧页
-   需要支持预写日志（`write-ahead log，WAL`），先改`WAL`再改页
-   使用锁存器控制并发



Pp. 76-83