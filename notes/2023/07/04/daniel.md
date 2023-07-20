不可靠的时钟

接收到消息的时间总是晚于发送时间，由于网络延迟的原因我们无法确定延迟的具体时长。这使得在多台机器参与的情况下很难确定事件发生的顺序。

网络中的每台机器都有自己的时钟，略快或略慢于其他机器。可以使用网络时间协议（NTP）来同步时钟。

时间日期时钟：根据某个日历（挂钟时间）返回当前日期和时间。如果本地时钟比NTP服务器提前太多，可能会被强制重置，并出现时间倒退的情况。这使得它不适合用于测量经过的时间。
单调时钟：例如System.nanoTime()。它们保证始终向前移动。时钟读取之间的差值可以告诉您经过了多长时间。时钟的绝对值毫无意义。NTP允许时钟速度加快或减慢最多0.05％，但NTP无法使单调时钟向前或向后跳跃。在分布式系统中，通常可以使用单调时钟来测量经过的时间（例如：超时）。