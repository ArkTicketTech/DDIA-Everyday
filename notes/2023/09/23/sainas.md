### Unreliable Networks

Shared nothing system:
Pro: no special hardware, can use cloud, multi-geographical

Internet: asyn packet network

Can be lost/delay/stop responding/response lost
Sender can not tell whether delivered

Impossible to tell why don't receive response

Handling: timeout


Software need to handle network failure properly.  (when it happens, cluster could become deadlocked or even delete all data)
Handling != tolerating them. Can throw error message

Just need to ensure system can recover from them

Deliberately trigger network problem and test
(Chaos Monkey)
