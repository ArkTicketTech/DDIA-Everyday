内存带宽和矢量化处理

-   减少从磁盘加载到内存的数据量
-   SIMD（列存储更有利于利用CPU周期）



列存储中的排序

-   存储顺序不重要(只需要知道A列中的k项和B列中的K项同属于同一行即可)
-   需要一次排序整行(?没懂)
-   有助于压缩列(游程编码)



几种不同的排序

-   C-Store：以不同的方式存储相同的数据来应对不同的查询
-   列存储中不保存指针，只是值



列存储的写操作

-   列存储有利于读，不利于写
-   使用LSM-Tree



聚合：数据立方体和物化视图

-   物化视图:创建缓存，不用每次都处理原始数据（查询结构的副本,保存在磁盘中）
-   底层数据发生变化，物化视图也需要更新，所以会影响写入性能
-   特殊情况：数据立方体或OLAP立方体(由不同维度分组的聚合网格)
    -   查询块
    -   不灵活

Pp. 97-107