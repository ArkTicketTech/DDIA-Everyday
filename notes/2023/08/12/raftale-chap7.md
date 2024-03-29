### 防止更新丢失
在讨论脏写的时候，行锁解决了脏写问题，但它没有解决所有的关于写的并发的问题。因为「读取后执行」的竞态条件并没有被真正的解决。

我们可以进一步思考，这个竞态条件是两个update更新两个对象，后一个update依赖于前一个update，等价于读取后执行的竞态条件，解决方案是对相同对象加写锁。写锁使得两个事务变成了真正的串行执行，但是那果场景变成了实际的「读取后更新」，比如计数器的例子，两个事务的写入由于写锁变成了串行执行，但读取写入整体上并不是串行执行的，写之前就读取到了写之前的值，最后必然就丢失了更新。所以脏写并没有解决有关写的所有并发问题。

当两个事务都有 「read-modify-write cycle」时，就其中一个事务可能发生丢失更新的问题。比如：
1. 并发更新计数器和账户余额；
2. 复合值的并发修改（如json文档中的列表字段，需要先读出，加一个字段后回写）
3. 两个用户同时修改wiki页面，并且都是修改后将页面完整覆写回。

解决方案：

1. 数据库提供特定的原子写功能：变成真正的串行化执行；
    1. 并不是所有的「read-modify-write」都可以用原子写来表达，但在可以使用的情况下是一种非常好的原则。
2. 显式上锁：避免数据库加锁（这有很大的性能损失，并不是所有的场景都能容忍），提高给应用层一个排他锁，让应用层根据实际情况加锁；
3. 乐观锁：CAS
4. 系统自动检查丢失更新：允许并发执行，事务管理器检测到丢失更新，则中止事务并强制它们充实「read-modify-write cycle」
    1. 结合快照隔离的版本号就能高效检测是否丢失更新

#### 原子写
有些数据库提供原子的（针对单个对象的）read-modify-write操作，例如下面的指令在大多数关系数据库下都是并发安全的：
```
update conters set value = value + 1 where key = 'foo'
```
与关系数据库类似：
1. 文档数据库如MongoDB，提供对文档局部的原子更新操作
2. kv存储如redis，支持对复合数据结构优先队列的原子更新

并不是所有的「read-modify-write」都可以用原子写来表达，或是原子写的成本太高。但在可以使用的情况下是一种非常好的原则。

#### 显式上锁（explicit locking）
防止丢失更新的另一个选择是让应用程序 显式地锁定将要更新的对象，然后应用程序可以执行读取 - 修改 - 写入序列，如果任何其他事务尝试同时读取同一个对象，则强制等待，直到第一个 读取 - 修改 - 写入序列 完成。
```sql
BEGIN TRANSACTION;
SELECT * FROM figures
  WHERE name = 'robot' AND game_id = 222
FOR UPDATE;

-- 检查玩家的操作是否有效，然后更新先前 SELECT 返回棋子的位置。
UPDATE figures SET position = 'c4' WHERE id = 1234;
COMMIT;
```

for update 子句告诉数据库应该对查询返回的所有行加锁。

#### 自动检测更新
允许事务并发执行，如果事务管理器检测到丢失更新，则中止事务并强制它们重试其 read-modify-write cycle.
丢失更新检测的好处是：它不需要应用代码使用for update，你可能会忘记使用锁和应用操作，从而引入错误；但丢失更新的检测是自动发生的，因此不太容易出错。

坏处是：如果回滚比较多，会有大量的重试风暴。

#### CAS
乐观锁，好处是比其加锁性能高，但缺点是：如果竞争大量出现，性能就会下降。
