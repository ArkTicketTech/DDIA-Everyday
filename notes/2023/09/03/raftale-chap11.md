#### 当消费者跟不上生产者时

如果消费者无法跟上生产者发送信息的速率，有三种选择：

1. 丢弃信息
2. 缓冲：将消息放入缓冲队列
3. 背压：阻塞生产者

基于日志的方法是缓冲的一种形式，具有很大但大小固定的缓冲区。

如果消费者远远落后，旧信息已经被覆盖掉后，消息代理实际上是丢弃了比缓冲区容量更大的旧信息。避免的方法：

1. 监控消费者落后日志头部的距离，如果落后太多就发出报警；
2. 即使消费者开始丢失消息，也不会中断其他消费者的服务。



#### 重播旧消息

AMQP和JMS风格的消息代理，处理和确认消息会将消息从代理上删除（使用的队列，出队即消失），但基于日志的消息代理，使用消息更像是从文件中读取数据，读数据时不会删除数据。

基于日志有一个优势就是：消费者偏移量是在消费者的控制下，如果需要重复消费的话可以很容易的操作。