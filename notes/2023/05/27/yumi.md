#第三章 存储与检索

散列索引

日志分段 压缩合并

但是，散列表索引也有其局限性：

散列表必须能放进内存。如果你有非常多的键，那真是倒霉。原则上可以在硬盘上维护一个散列映射，不幸的是硬盘散列映射很难表现优秀。它需要大量的随机访问 I/O，而后者耗尽时想要再扩充是很昂贵的，并且需要很烦琐的逻辑去解决散列冲突【5】。
范围查询效率不高。例如，你无法轻松扫描 kitty00000 和 kitty99999 之间的所有键 —— 你必须在散列映射中单独查找每个键。
