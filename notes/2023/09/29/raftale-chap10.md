批处理系统（离线系统），批处理作业的主要性能衡量标准通常是吞吐量（处理特定大小的输入所需的时间）



## 使用Unix工具的批处理



### 简单日志分析

如果你想在你的网站上找到5个最受欢迎的网页，则可以在unix shell中这样做：

```bash
cat /var/log/nginx/access.log | #1
  awk '{print $7}' | #2
  sort             | #3
  uniq -c          | #4
  sort -r -n       | #5
  head -n 5          #6
```



1. 读取日志文件
2. 将每一行按空格分割为不同的字段，每行只输出第7个字段，恰好是请求的url。
3. 按字母顺序排列请求的URL列表；
4. uniq检查两个相邻的行是否相同来过滤掉输入中的重复行；-c表示还要输出一个计数器；
5. 按请求次数（-n）进行逆序排序（-r）
6. 只输出前5行



#### 命令链与自定义程序

还可以写程序来处理

#### 排序 vs 内存中的聚合





### Unix哲学

unix管道：需要一种类似园艺胶管的方式来拼接程序，当我们需要将消息从一个程序传递给另一个程序时，直接接上去就行。



1. 让每个程序都做好一件事情；
2. 期待每个程序的输出称为另一个程序的输入
3. 尽早重构
4. 优先使用工具来减轻编程任务



#### 统一的接口

如果你希望一个程序的输出成为另一个程序的输入，那意味着这些程序必须使用相同的数据格式。也就是一个兼容的接口。

在UNix中，这种接口是一个文件。一个文件只是一串有序的字节序列。



许多unix程序将这个字节序列称为ASCII文本。





#### 逻辑与布线相分离

Unix工具的另一个特点是使用标准输入（stdin）和标准输出（stdout）。如果你运行一个程序，而不指定任何其他的东西，标准输入来自键盘，标准输出指向屏幕。但是，你也可以从文件输入输出重定向到文件。管道允许你讲一个进程的标准输出附加到另一个进程的标准输入（有个小内存缓冲区，而不需要将整个中间数据流写入磁盘）



Unix工具的最大局限是它们只能在一台机器上运行，Hadoop这样的工具应运而生。



## MapReduce和分布式文件系统



MapReduce有点像Unix工具，但分布在数千台机器上面。

一个MapReduce作业可用和一个Unix进程相类比：它接受一个或多个输入，并产生一个或多个输出。

运行Mapreduce作业通常不会修改输入，输出文件以连续的方式一次性写入。

Unix工具使用stdin和stdout作为输入和输出，但MapReduce作业在分布式系统上读写文件。

在Hadoo的MapReduce实现中，该文件系统被称为HDFS（Hadoop分布式文件系统），一个google文件系统（GFS）的开源实现。



除了HDFS外，还有各种其他分布式文件系统，如GlusterFS和QFS。



共享架构是指内存和磁盘可用在同一个操作系统下相互连接，但HDFS不是共享架构。HDFS在每台机器上运行了个一守护进程，它对外暴露网络服务，允许其他节点访问存储在该机器上的文件。名为NameNode的中央服务器会跟踪哪个文件块存储在哪台机器上。



为了容忍机器和磁盘故障，文件块被复制到多台机器上。

HDFS的可伸缩性很强，最大的HDFS部署在上万条机器上，总存储容量达到数百PB。





### MapReduce作业执行



MapReduce是一个编程框架，你可以使用它编写代码来处理HDFS等分布式文件系统中的大型数据集。



MapReduce

1. 读取一组文件，并将其分解为记录（records）。
2. 调用Mapper函数，从每条输入记录中提取一对键值；
3. 按键排序所有的键值对
4. 调用Reducer函数遍历排序后的键值对，如果一个键出现多次，排序使它在列表中相邻，所以很容易组合这些值而不必在内存中保留很多状态。



这四个步骤可用作为一个MapReduce作业执行，步骤2（Map）和步骤4（Reduce）是你编写自定义数据处理代码的地方。步骤1由输入格式解析器处理，步骤3的排序步骤隐含在MapReduce中， 你不必编写它，因为Mapper的输出始终在送往Reducer之前进行排序。



要创建MapReduc作业，你需要实现两个回调函数，Mapper和Reducer，其行为如下：

1. Mapper：
2. Reducer：



#### 

#### 分布式执行MapReduce

Mapper和Reducer一次只能处理一条记录，它们不需要知道它们的输入来自哪里，或者输出往什么地方，所以框架可用处理在机器之间移动数据的复杂性。






- 每个输入文件的大小通常是几百兆字节
- MapReduce框架会将代码（jar文件）复制到机器上，然后启动Map任务并开始读取文件进行Mapper任务，在当前输入文件副本的机器上运行Mapper任务，数据计算就近原则，减少网络开销；
- Reduce任务的数量由作业的作者来配置。为了确保具有相同键的所有键值对最终落在相同的 Reducer 处，框架使用键的散列值来确定哪个 Reduce 任务应该接收到特定的键值对；
- 键值对必须进行排序，但数据量太大，无法在单台机器上使用常规排序算法；
- 每个Map任务都按照Reducer对输出进行分区，每个分区都被写入Mapper程序的本地磁盘，当Mapper任务结束后，Mapper调度器会通知Reducer可以从Mapper开始获取输出文件，Reducer下载自己相应分区的有序键值对文件。




