### 基于触发器的复制

虽然基于行的复制已经做了一些分离，但是其实仍然局限在数据系统内部。如果用户要进行：

1. 对需要复制的数据进行过滤，只复制一个子集。
2. 将数据从一种数据库复制到另外一种数据库。

那么就需要将复制方法从数据系统中完全隔离出来，可以使用数据系统提供的工具，提取数据，然后由其他节点导入。

1. Oracle Golden Gate
2. 触发器
3. 存储过程

## 复制延迟问题

回顾一下我们为什么要复制（多副本）：

1. 可用性
2. 可伸缩性
3. 低延迟
