Fixed Weighting load balancing method
权重最高的应用服务器将接收所有流量。如果权重最高的应用服务器发生故障，所有流量将被引导至下一个权重最高的应用服务器。相当于使用了priority queue。

Fixed weighting is a load balancing algorithm where the administrator assigns a weight to each application server based on criteria of their choosing to represent the relative traffic-handling capability of each server in the server farm. The application server with the highest weight will receive all of the traffic. If the application server with the highest weight fails, all traffic will be directed to the next highest weight application server. This method is appropriate for workloads where a single server is capable of handling all expected incoming requests, with one or more “hot spare” servers available to pick up the load should the currently active server fail.

Weighted Response Time load balancing method load balancing method
哪个server的响应时间短就继续用谁。

The weighted response time load balancing algorithm that uses the application server’s response time to calculate a server weight. The application server that is responding the fastest receives the next request. This algorithm is appropriate for scenarios where the application response time is the paramount concern.
