Write Skew and Phantoms
再来回顾：
1. 脏写：两个写之间有数据的约束，但并发导致了第一个写被覆盖，破坏了约束，解决方法就是不能覆盖未提交的写；
2. lost update：针对同一对象先读后写，读写之间也有数据约束，但并发导致了读的数据在写之前失效，但稍后的写是在失效的读的基础上的更新，导致其他的写数据丢失，解决方法是针对同一对象使用原子写或者加锁或CAS重试，本质上就是原子写。

但还有一种竞态条件，读取一批对象，然后分别针对其中部分不同的对象进行更新，读取一批对象后的聚合结果决定了接下来的写入（一致性约束）。看起来似乎没有发生冲突。但事实上一个事务的写入破坏了读取的那一批对象的聚合结果，使另一个事务的读取结果失效。这种异常叫做write skew。
本质上还是read-modify-write，一个事务的写入导致另一个事务读取到的信息失效
写入偏差的一些例子：
1. 会议室预订系统：
   a. 先检查某个会议室指定时间12:00 - 13:00是否有被预订
   ⅰ. SELECT COUNT(*) FROM bookings WHERE room_id = 123 AND end_time > '2015-01-01 12:00' AND start_time < '2015-01-01 13:00';
   b. 没有预订则进行预订，事务A预订12:00-12:40， 事务B预订12:30 - 13:00
   ⅰ. 事务A和事务B的并发就会导致写入偏差，因为它们两预订的同一个会议室发生了时间上的冲突
2. 多人游戏：写锁能够确保两个玩家不能移动同一个棋子，但是并不能阻止玩家将两个不同的棋子移动棋盘上的相同位置。
   a. 事务1读ABC，写A->C；事务2读ABC，写B->C
3. 抢注用户名：
   a. 检测用户名是否被注册，写入注册用户。
4. 防止双重开支：
   a. 用户对项目进行消费，事务1消费项目A，事务2消费另一个项目B，用户的余额只能单独支撑项目1和项目2，如果并发可能导致两个项目都进行了消费，一起导致余额变成了负数。
   b. 事务1读总额和项目A的开支，能够买A；事务2读总额和B的开支，能够买B。但事务1和事务2并发执行的时候，会导致余额为负数。

所有的这些例子都遵循类似的模式
1. 一个select查询找出所有符合条件的行，并检查是否符合一些要求
   a. 至少有两名医生在值班；
   b. 会议室同一时间还没有进行预订
   c. 棋牌上的位置没有被其他棋子占据
   d. 用户名还没有被抢注
   e. 账户里还有足够余额
2. 按照第一个查询的结果，应用代码决定是否继续（可能会继续操作，也可能中止并报错）
3. 如果应用决定继续操作，就执行写入，并提交事务
   a. 这个写入的效果改变了步骤2的先决条件，例如：
   b. 少了一个医生值班
   c. 会议室已经被预订了
   d. 棋盘上这个位置已经被占领
   e. 用户名已经被抢注：唯一约束可以解决
   f. 账户余额不够了
   这些例子中，步骤3修改的行，是步骤1返回的行之一。
   幻读：一个事务的写入改变了另一个事务的搜索查询的结果。快照隔离避免了只读查询中的幻读，小于等于当前事务ID的数据不可见，但是读写事务中，读的不可见意味着接下来的写会产生冲突。

dirty write	写A	写B
写A	写B
竞态条件	A和B存在一致性约束
lost update	读A	写A
读A	写A
A的读和写存在一致性约束
write skew	读AB	写A
读AB	写B
竞态条件	f(A,B)=x
A和B整体上形成一致性约束

物化冲突
解决幻读的手段之一是：人为的引入锁对象将幻读的数据变成具体的行的冲突。
比如会议室预订中，竞态条件是某个会议室的预订时间，如果将会议室和预订时间绑定起来作为单个对象的读写，那预订会议室就变成对单个对象的读写竞争，这种竞争就转变成了lost update中的问题。
抢注用户名：唯一约束，第二个事务在提交时会因为违反唯一性约束而终止。