### Unreliable Clocks
应用程序依赖时钟，例如：
* 依赖于持续时间（用于测量请求发送和响应接受的时间间隔）
* 依赖于特定时间点完成某些工作

分布式场景中，跨节点通信导致的不确定延迟问题，导致了多节点通信时很难确定事情发生的先后顺序。

另外，网络上的每台机器都有自己的时钟硬件设备（通常为石英晶体振荡器），但这类设备并非却对准确，机器间存在差异。为了同步不同机器间的时间，可以使用网络时间协议（Networker Time Protocol，NTP）来同步获取高精度时间。

#### 1. Monotonic Versus Time-of-Day Clocks
Time-of-day clocks：墙上时钟，钟表时钟
Monotonic clocks：单调时钟

##### Time-of-day clocks
A time-of-day clock does what you intuitively expect of a clock: it returns the current date and time according to some calendar (also known as wall-clock time).

Linux 中的 clock_gettime(CLOCK_REALTIME)，Java 中的 System.currentTimeMillis() 都是墙上时钟，且其返回距离 UTC 以来的秒数和毫秒数。

墙上时钟可以与 NTP 同步，但存在精度问题（忽略闰秒），导致其不适合测量时间间隔。

##### Monotonic Clocks
单调时钟适合测量持续时间间隔，其保证时间先前，不会出现墙上时钟的回拨现象。

可以两次取单调时钟来计算时间间隔。单调时钟的绝对值没有任何意义，因此比较不同节点上的单调时钟值毫无意义，因为其并没有相同的基准。

如果服务器有多路 CPU 且每个 CPU 可能有单个的计时器，且不与其它 CPU 进行同步，应用程序的线程可能调度到不同 CPU 上，此时，需要操作系统来补偿多个计时器之间的偏差，来为应用层提供统一的单调递增计时。

如果NTP检测到本地石英比时间服务器上更快或者更慢， NTP会调整本地石英的震动频率，但 NTP 不会直接调整单调时钟向前或者回拨。