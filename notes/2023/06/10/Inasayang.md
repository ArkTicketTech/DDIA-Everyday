检测并发写

-   网络不稳地和节点失效，造成不同节点不同的请求顺序
-   所有副本应该收敛于相同的内容
-   方案
    -   最后写入者获胜（丢弃并发写入）（`last write wins，LWW`）
        -   副本总是保存新值，丢弃旧值
        -   如何确认值是新旧
            -   对请求强制排序（如，加时间戳）
        -   问题
            -   代价是数据持久性，保留新值，丢弃旧值（旧值不保留不也没关系吗）
            -   可能删除非并发写（？不懂）
        -   写入一次后，视为不可变（没懂）
    -   Happens-before关系和并发
        -   是否存在因果关系操作
            -   存在，可以覆盖
            -   不存在，需要解决冲突
        -   如何判断是否存在因果关系
            -   版本号
                -   写入时递增
                -   写之前必须先读
                -   写请求必须包含之前的版本号和值
                -   覆盖旧版本值，保留新版本所有值



Pp.  175-180