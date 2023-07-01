P162-P167

### Problems with Replication Lag

Leader-based replication:  Attractive for read heavy system

*read-scaling* architecture: many followers (BUT must be asynchronous)

Asyn follower: temp inconsistency

When the followeres catch up: eventual consistency

#### Reading Your own Writes

*read-after-write consistency*   OR *read-your-writes consistency*

How to implement

- **(All leader)**Things user may modify -> read only from leader
  How to know what are the things user may modify?
  e.g. user profile
  user's own profile -> always from leader
  other user's profile -> always from followers
- **(Earlier Leader, then followers)**If most things can be modified by user, that is not effictive
  Track time of last update
  1min from last update: read from leader
  1min+ from last update: choose followers with lag < 1min
- **(Followers: choose by lag)**Client can remember timestamp of most recent write
  Choose replica with last update >= that timestamp
  (If not sufficiently up to date: choose another, or wait)

More complex with multi-datacenter:
Request to leader must be routed to the datacenter that leader is in

More complex with use accessing from multi-device
*cross-device* read-after-write consistency:

- Remembering last update timestamp is more difficult
  Metadata will need to be centralized
- Requests from different devices may be routed to different datacenter
  Need to make sure route to the same datacenter first if must read from the leader

#### Monotonic Reads

*moving backward in time*

If you query a follower with lag A, then another follower with lag B, B > A

*strong consistency > Monotonic reads > eventual consistency*

How to achieve:
User always read from same replica
e.g. replica chosed by hask of userID

Problem:
When replica fails, will need rerounting

#### Consistent Prefix Reads

concerns violation of causality

If some partitions are replicated slower than others, an observer may see the answer before they see the question.

*Consistent Prefix Reads*

Guareetee if writes happen in an order, reading those will see the same order

Particular problem in partitioned database, many have no global ordering writes

Solution:

1. Any causally related writes to the same partition (sometimes not efficidenly)
2. Algorithm "happen-before"  page 186

#### Solutions for Replication Lag

Those stronger guarantee, such as read-after-write, pretends the replication is synchronous when it's actually asynchronous for minutes

Application can provide stronger guarantee than DB: e.g. run certain reads only on leader (more complexity)

But it's better developer didn't have to worry about repliaction issue

That's why *transaction* exist

Single-node transaction: simple
Distributed db: many have abandoned it, too expensive
