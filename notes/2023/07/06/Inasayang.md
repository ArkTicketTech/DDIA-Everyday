全序关系广播

-   节点间交换消息的协议
    -   可靠发送
        -   没有消息丢失，只要到达了一个节点，则会到达所有节点
    -   严格有序
        -   消息总是以相同顺序发送到每个节点
-   使用全序关系广播
    -   zookeeper和etcd已实现（全序关系广播与共识有联系）
    -   状态机复制（数据库复制）
        -   每条消息代表数据库写请求，每个副本按找相同的顺序处理写请求，则所有副本保持一致
    -   用来实现可串行化事务
        -   每条消息表示一个确定性事务且作为存储过程来执行，每个节点使用相同的执行顺序，则所有副本保持一致
    -   消息顺序在发送时已确定
    -   可以理解为追加式跟新日志



全序关系广播实现线性存储...

线性存储实现全序关系广播...



看不下去了...



Pp. 327-330