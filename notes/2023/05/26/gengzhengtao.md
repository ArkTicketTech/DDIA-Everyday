P20-P26
## 描述性能
负载增加，但系统资源保持不变，系统性能会发生什么变化
负载增加，如何保持性能不变，需要增加多少资源
throughput reponse time
latency reponse time

关注中位数指标，百分位数，
百分位数通常用于描述、定义服务质量目标 Service level Objectives，和服务质量协议。Service level Agreement

## 应对负载增加的方法首先， 针对特定 别负载而设计的架构不太可能应付超出预设目标 10 倍的实际负载
如果目标服务处于快速 长阶段，那么需要认 考虑每增 个数 级的负载，
应如 设计
首先， 针对特定 别负载而设计的架构不太可能应付超出预设目标 10 倍的实际负载
如果目标服务处于快速 长阶段，那么需要认 考虑每增 个数 级的负载，
应如 设计

垂直扩展-水平扩展

无状态服务--水平扩展
有状态服务，尽量垂直

# 可维护性
软件系统的三个设计原则
可运维性
简单性
可演化性
