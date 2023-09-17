stream processing

ublike batch processing, input data of stream processing is unbounded
it consists of event
each event is a small and self contained information unit. could be a cpu metric or an user action

# methods of stream processing
1. direct messaging
like tcp or udp. 1 to 1
simple but cannot tolerate consumer failure
also cannot handle backlog well. very limited scenario

2. intermediary message queue
provides durability and centralized management for events
also good notification functionality for consumer. no polling overhead

# type
1. load balancing
an event is deliverred to a single consumer
good when processing is slow and we can increase # of consumers

2. fan out
broadcast to all consumers
good if we need different processing methods and therefore different consumer types

they can be combined if we introduce consumer groups
