# Part III Derived Data
存储和处理数据的系统可以分为两大类：
* 记录系统（System of record）：source of truth，normalized
* 衍生数据系统（Derived data systems）：redundant


## Chap10 Batch Processing
三种不同类型的数据系统：
* Services (online systems)：服务等待客户的请求或指令到达。每收到一个，服务会试图尽快处理它，并发回一个响应。响应时间通常是服务性能的主要衡量指标，可用性通常非常重要（如果客户端无法访问服务，用户可能会收到错误消息）。
* Batch processing systems (offline systems)：- 一个批处理系统有大量的输入数据，跑一个 **作业（job）** 来处理它，并生成一些输出数据，这往往需要一段时间（从几分钟到几天），所以通常不会有用户等待作业完成。相反，批量作业通常会定期运行（例如，每天一次）。批处理作业的主要性能衡量标准通常是吞吐量（处理特定大小的输入所需的时间）。本章中讨论的就是批处理。
* Stream processing systems (near-real-time systems)：流处理介于在线和离线（批处理）之间，所以有时候被称为 **准实时（near-real-time）** 或 **准在线（nearline）** 处理。像批处理系统一样，流处理消费输入并产生输出（并不需要响应请求）。但是，流式作业在事件发生后不久就会对事件进行操作，而批处理作业则需等待固定的一组输入数据。这种差异使流处理系统比起批处理系统具有更低的延迟。