#### 非因果序列号生成器

如果主库不存在或不是单一的，比如无主复制和多主复制系统、分区的数据库。

1. 每个节点都可以生成自己的独立的一组序列号，比如一组奇数，一组偶数，然后上面再加上时间戳；
2. 可以预先分配序列号区块，比如节点A分配1-1000，节点B分配1001-2000

它们比单一主库的自增ID更具有伸缩性，但它们都有一个问题：生成的序列号无法在全局上确定因果性（即不是全序的）



#### 兰伯特时间戳

兰伯特时间戳是一个逻辑时间戳，每个节点和每个客户端跟踪迄今为止所见过到的最大计数器值，请在每个请求中包含这个最大计数器值，当一个节点收到最大计数器值大于自身计数器的请求和响应时，它立即将自己的计数器设置为这个最大值。

兰伯特时间戳是全序的，但无法分辨两个操作是并发的还是因果依赖的。

#### 光有时间戳排序还不够

兰伯特时间戳无法识别并发，比如创建唯一用户名，节点需要马上决定请求失败还是成功，但是节点并不知道是否存在其他节点是否并发执行相同的操作。为了确保没有其他节点正在使用相同的用户名和较小的时间戳并发创建同名账户，你必须检测其他每个节点在做什么。

 只有在所有的操作都被收集之后，操作的全序才会出现。比如实现创建唯一用户名上的这种唯一性约束，仅有操作的全序是不够的，还需要直到这个全序何时会尘埃落定。如果你有一个创建用户名的操作，并且确定在全序中没有任何其他节点可以在你的操作之前插入对同一用户名的声称，那么你就可以安全的宣告操作执行成功。



如何提前检测到全序关系，需要用到全序广播。



### 全序广播

全序广播解决的问题是能够真正检测到并发的顺序，并反馈给客户端，而不是在最后一刻使用LWW，LWW会直接丢弃，客户端无感知。

全序广播通常被描述为在节点间交换消息的协议，它需要满足两个安全属性：

1. 可靠交付：没有消息丢失：如果消息被传递到一个节点，它将被传递到所有节点。
2. 全序交付：消息以相同的顺序传递给每个节点。

正确的全序广播算法必须始终保证可靠性和有序性，即使节点或网络出现故障。当然在网络中断的时候，消息是传不出去的，但是算法可以不断重试，以便在网络最终修复时，消息能及时通过并送达（当然它们必须仍然按照正确的顺序传递）。



#### 使用全序广播

 ZooKeeper 和 etcd 这样的共识服务实际上实现了全序广播。

全序广播的一个重要表现是，顺序在消息送达时被固化，如果后续的消息已经送达，节点就不允许追溯地将先前的消息插入顺序中的较早位置。

全序广播是异步的，消息被保证以固定的顺序可靠的传送，但是不能保证消息何时被送达，

#### 使用全序广播实现线性一致性的存储

全序广播是异步的，消息被保证以固定的顺序可靠的传送，但是不能保证消息何时被送达。

有了全序广播，你就可以在此基础上构建线性一致性的存储。

对于每一个可能的用户名，你都可以有一个带有CAS原子操作的线性一致性寄存器，每个寄存器最初的值为空值（表示未使用该用户名）。当用户想要创建一个用户名时，对该用户名的寄存器执行 CAS 操作，在先前寄存器值为空的条件，将其值设置为用户的账号 ID。如果多个用户试图同时获取相同的用户名，则只有一个 CAS 操作会成功，因为其他用户会看到非空的值（由于线性一致性）。



1. 在日志中追加一条消息，试探性的指明你要声明的用户名
2. 读日志，并等待你刚才追加的消息被读回；
3. 检查是否有任何消息声称目标用户名的所有权。如果这些消息中的第一条就是你自己的消息，那么你就成功了：你可以提交声称的用户名（也许是通过向日志追加另一条消息）并向客户端确认。如果所需用户名的第一条消息来自其他用户，则中止操作。

注意这里的全序广播只针对一个主分区，不针对跨分区，跨分区还需要额外的协调工作

由于日志项是以相同顺序送达至所有节点，因此如果有多个并发写入，则所有节点会对最先到达者达成一致。选择冲突写入中的第一个作为胜利者，并中止后来者，以此确定所有节点对某个写入是提交还是中止达成一致。

简单来说，这里是多个客户端预先对主分区进行了消息写入，消息写入的顺序就是并发的顺序，所以全序广播做的一件事情就是 在并发写前做了一个动作来确定真正的并发顺序，然后再进行写入，而不是在最后写入的时候进行决断。好处可以细品。

这一过程保证写入是线性一致的，但它并不保证读取也是线性一致的。为了使读取也具有线性一致性：

1. 线性化的方式获取当前最新消息的位置，确保该位置之前的消息都已经读取到，然后再进行读取；
2. 在日志中加入一条消息，收到回复时真正进行读取，这样消息在日志中的位置可以确定读取发生的时间点
3. 从保持同步更新的副本上读取数据