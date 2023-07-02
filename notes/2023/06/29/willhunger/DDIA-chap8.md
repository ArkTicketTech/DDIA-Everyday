#### 4. Process Pauses
假如数据库只有一个主节点，只有主节点可以写入，那么其它节点如何在没有被宣告失败的情况下安全写入呢？

租约机制：拿到租约并且定期更新租约的节点，才能成为主节点，否则会被认为发生故障，续约失败。

```cpp
while (true) {
	request = getIncomingRequest();
	// Ensure that the lease always has at least 10 seconds remaining
	
	if (lease.expiryTimeMillis - System.currentTimeMillis() < 10000) {
		lease = lease.renew();
	}
	
	if (lease.isValid()) {
		process(request);
	}

}
```

代码中存在的问题：
1. 依赖同步时钟，并且和本地时钟进行比较。
2. 大多数情况下，检查点和处理请求间隔时间短，10s 足够来处理请求。但如果程序出现暂停，在 `lease.isValid()` 消耗了 15s，则开始处理请求时，租约已经过期，此时其它节点已经接管了主节点，此时导致了系统中出现了两个主节点。
