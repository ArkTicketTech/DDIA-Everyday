P230-P234

#### 防止丢失更新
读-提交和快照级别隔离，主要都是为了解决只读事务遇到并发是可以看到什么，中间会涉及到脏读的问题，
  原子写操作，
  显示加锁，应用层控制
  自动检测更新丢失，借助快照级别隔离
  原子比较和设置
  冲突解决与复制--多住节点或者无主节点的多副本数据库，LWW
### 写倾斜与幻读
数据写入的竞争状态
  
