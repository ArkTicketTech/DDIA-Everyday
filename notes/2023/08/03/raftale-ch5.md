## 多主复制是什么
前面讲的是单主复制，也就是一个主库，所有的写入必须通过它。
多主复制指的是同时存在多个主库，同时每个主库也是其他主库的从库。

## 为什么会有多主复制
单个数据中心使用多主复制意义不大，因为复杂度大大增加。
多主复制一般用于多个数据中心，比如你的业务散落在全球时，有多个异地数据中心可以使得用户的访问速度更快。

## 多主复制的好处
多主配置中，每个写操作都可以在本地数据中心进行处理，性能会更好
数据中心停机时，可以切换另一个数据中心

## 多主复制的缺点
写冲突：多个不同的数据中心可能会同时修改相同的数据。
某些数据库的功能使用有风险：自增主键、触发器、完整性约束

### 如何处理写冲突问题
最简单的策略是避免冲突，确保来自特定用户的请求始终路由到同一数据中心，从用户的角度来看，本质上就是单主配置了
其他策略有：
1. 同步与异步冲突检测：等待写入被复制到所有副本，再告诉用户写入成功，缺点就是失去了多主复制的优点。
2. 收敛至一致的状态：多主配置中，没有明确的写入顺序。如果给每个写入一个带有优先级的唯一ID，可以实现冲突的合并，但也意味着会丢失其他数据
3. 自定义冲突解决逻辑：应用程序解决冲突。
    1. 写时执行：只要数据库系统检测到复制更改日志中存在冲突，就会调用冲突处理程序（不明白这个冲突处理程序如何处理冲突）
    2. 读时执行：类似于git的分支合并冲突，让用户来解决冲突 或是自动解决冲突。
