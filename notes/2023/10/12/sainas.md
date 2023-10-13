### Network congestion and queueing
- No bandwidth, queueing or dropped
- Target CPU busy, queueing
- Virtualized env, running OS pauses for tens of milliseconds while another VM 
use the CPU, incoming data is buffered by VM monitor, further increasing the network delays
- TCP flow control  (backpressure) (throttling on the sender side)

TCP considers a package lost and retransmits -> app see the delay

### TCP Versus UDP
latency-sensitive use UDP
- videoconference
- phone call

UDP -> no retransmit. But still susceptible to switch queue and scheduling delays

UDP is good when delayed data is worthless


