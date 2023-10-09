### Detecting Faults

Auto detect: load balancer detects bad node. Single leader DB, follower be promoted auto

Network: hard to detect
- can reach machine, but no process is listening the destination port, OS will close TCP by sending RST or FIN packet.
But if node crashed, no way to know how much data was processed

- Node process crashes, OS is still running, a script can notify other node and take over quickly rather than waiting for timeout (HBase)
- If can access Network switch in data center: query to detect link failure. But this option is ruled out in many cases
- If router is sure the IP is unreachable, it may reply ICMP Destination Unreachable package.


Rapid feedback about remote node being down is useful but can't rely on it. (Maybe delivered but crash before handling)
Need positive feedback from app

May get error response but you should also assume get no response.

Retry(TCP retries transparently but you may also retry at app level), wait timeout
