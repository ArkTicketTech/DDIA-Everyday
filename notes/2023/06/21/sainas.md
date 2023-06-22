P144-P158


# PART II. Distributed Data

Why multiple machine?

1. Scalability
2. Availability
3. Latency (geo location)

Scaling to Higher Load:

1. Vertical scaling/Scaling up
   - Shared-memory architecture
     Problem: price is not linear, and efficiency gain is worst than linear
     Not fault tolerance. (But some allows hot-swappable)
     One geo location
   - Shared-disk architecture
     Used for data warehousing workloads
     Locking is difficult to handle
2. Horizontal scaling/Scaling out
   - Shared-nothing architecture
     With cloud virtual machines now multi-region is feasible for even small companies

Ways to distribute data across nodes:

- Replication
- Partition

## Chapter 5. Replication

Why replicate?

- Geographically closer to user(Lower latency)
- failover(high availability)
- more nodes to serve read (high read throughput)

Three popular algorithms

- single-leader
- multi-leader
- leaderless replication

### Leaders and Followers

1. Clients must send write request to leader. Leader writes to local storage
2. Leader sends data to followers as *replication log* or *change stream*
   Followers apply the writes in the same order
3. Read can be handle by both leader and followers. Writes are only accepted on the leader

Built-in feature of many db e.g. PostgreSQL, MySQL, MongoDB
And some message queue Kafka RabbitMQ highly availability queues

#### Synchronous Versus Asynchronous Replication

When the leader notify the client that the update has been successful?
Wait until the follower confirms the write: That follower is synchronous
Not wait for the follower: That follower is asynchronous

| --   | Synchronous                                                  | Asynchronous    |
| ---- | ------------------------------------------------------------ | --------------- |
| Pros | Guarantee consistency                                        | Not up-to-date  |
| Cons | Leader blocks write if one follower doesn't respond (crashed or network issue) | Not block write |

Impractical if all followers are synchronous

*semi-synchronous:*

- usually one synchronous and others async 
  If that one sync unavailable or slow, another async is made sync

- This make sure two up-to-date copies

*completely asynchronous*

- Write can be lost if leader failed (Weakening durability)
- Can continue processing write even all followers fall behind

Research on not losing data if leader fails:
*chain replication*

#### Setting Up New Followers

Just copy is not sufficient, since data is always in flux
Could lock the DB: against goal of high availability

Process

1. Snapshot leader's DB (without lock the entire db)
2. copy snapshot to new node
3. new node connects to leader and request data changes in between (snapshot is associated with one position in leader's replication log)
4. New node process the backlog and *"caught up"*


#### Handling Node Outages

e.g. Reboot to install security patch. Reboot without downtime

**Follower failure: Catch-up recovery**

Follower has all data change logs received from leader

Request to leader for changes since the failure

**Leader failure: Failover**

Promote one follower

- Client need to send writes to new leader
- Other followers need to consume data from new leader

This is called *failover*

Steps

1. Determining that the leader has failed.
   Nodes bounce messages between each other, if no response in long time
2. Choosing a new leader
   Election process, or appointed by *controller node*. Consensus problem
   Best candidate: most up-to-date
3. Reconfiguring the system
   If the old leader comes back, system need to handle it

Failover is fraught with things that can go wrong:

- asynchronous replication: data loss
  If old leader rejoin: what to do with those writes?
  Common solution: discard. May violate durability expectation

- Discarding writes can be dangerous if other storage system coordinates with DB
  GitHub autoincrement primary key. New leader lagged, reuse some primary keys, also used in Redis, caused private data to be disclosed to the wrong users
- Two new leaders: *split brain*
  data lost/corrupted. Two node accepts conflict writes
  Solution: mechanism to shut one down. But if not careful can shut two down
- What's the right time out for leader to be declared dead?
  Too long: long recovery
  Too short: unnecessary, load spike/network issue, making things worse

No easy solution. Some team prefers to do failovers manual


