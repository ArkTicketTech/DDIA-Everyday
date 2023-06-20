P136-P140


**RPC (remote procedure calls): Data encoding and evolution**

Servers update first, clients second, thus

- Backward compatibility on requests
- Forward compatibility on response

RPC compatibility are inherited from encoding (Avro, SOAP, RESTful JSON...)

Hard since can not force client to upgrade

- Need maintain compatibility for a long time
- If breaking change needed, ends up maintaining multiple versions of API

API Versioning:

There is no agreement
RESTful: version in URL or HTTP header
Or if client uses API key, store the version in DB and modified through a separate admin interface

#### Message-Passing Dataflow

*asynchronous message-passing*

|       | REST & RPC  | Database                     | Message-Passing                                              |
| ----- | ----------- | ---------------------------- | ------------------------------------------------------------ |
| Speed | Immediately | Store and read in the future | In between, like both: client's request is delivered with low latency. Message not sent via direct network connection, but with an intermediary |

*message broker* (*message queue* or message-oriented middleware): stores the message temporarily.

Message broker Pros: (over RPC)

- Act as a buffer (improve reliability)
- Auto redeliver
- Avoid sender needing to know IP & port of recipient (Useful in cloud, virtual machines come and go)
- One message to several receipents
- Logically decouple sender from recipient (sender only public message, doesn't care who consumes)

Different from RPC: only one-way communication

**Message brokers**

producers   --publish-->  *queue* or *topic*   <--subscribe--  *consumers* or *subscribers*

Many to many

One topic is one-way, but a consumer can publish too, to a reply queue

Typically any encoding format works

If a consumer republish message, need to preserve unknown field (like the same issue in DB)

**Distributed actor frameworks**

*actor model*:

- Each actor has local state(not shared), communicates asynchronously

- Concurrency in a single process (no threads, thus no race conditions, locking, deadlock)

- *Location transparency* is better than RPC since actors assumes messages might be lost

*distributed actor framework*: actor + message broker
Still need to worry about compatibility

### Summary

Rolling upgrade: allows no downtime, less risky (roll back before affecting more user)

These properties are hugely beneficial for "*evolvability*"

Backward and forward compatibility
(Must assume different versions are running)
