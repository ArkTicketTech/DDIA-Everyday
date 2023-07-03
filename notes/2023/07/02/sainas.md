P167-P193

### Multi-Leader Replication

One leader downside: all write must go through it
If can't connet to the one leader, can't write to DB



#### Use Cases for Multi-Leader Replication

##### 1. Multi-datacenter operation

Good for:

- Performance
  Less latency to writes

- Tolerance of datacenter outages

  If a datacenter fails:
  Single leader: need to promote a follower of another data center
  Multi-leader: can continue operating till it's back

- Tolenrance of network problem
  Traffic between datacenter uses public internet (less reliable than local network)
  Single-leader: sensitive to inter-datacenter link
  Multi-leader: better. Network interruption doesn't block writes

Downside:
Conflicts

Dangerous (autoinrement, triggers, integrity constrains can be troublesome)

##### 2. Clients with offline operation

Like calendar app on your phone, every device's local db acts as a leader

Replication lag can be days

##### 3. Collaborative editing

*Real-time collaborative editing* 

e.g.Google Doc

Not a database replication problem, but similar

Need lock on the doc, but unit must be small (single key stroke)

#### Handling Write Conflicts

e.g.  
User 1 changes title from A -> B
Uder 2 changes titile from A -> C
Both consider successful to local leader

Approach

1. **Conflict avoidance**
   Since many implementations of multi-leader replication handleconflicts quite poorly, avoiding conflicts is a frequently recommended approach
   e.g. user can edit profile data. Make these requests always route to the same datacenter "home" datacenter.
   From user's point of view it's like single-leader
   (But designated leader may change due to datacenter failure or user moving)
2. **Converging toward a consistent state**
   Can't apply the last writes:
   In the example, leader 1 sees B then C. Leader 2 sees C then B
   Must eventually be the same
   the database must resolve the conflict in a *convergent* way
   - each write a unique ID, highest ID wins
     timestamp: *last write wins*
     Or random number, hash...
     Can cause data loss
   - Each replica a unique ID, writes on higher-numbered replica wins
     Can cause data loss
   - Merge values. Sort alphabetically then concatenate
     i.e.  B/C
   - Preserve all info, write application code that resolves the conflicts later 
     e.g. prompting user
3. **Custom conflict resolution logic**
   Resolution logic in application code
   - On writes
     Can not prompt user
   - On read
     Save all versions and may prompt user or automatically resolve

**Automatic conflict Resolution**

- *Conflict-free replicated datatypes* (CRDTs) 
  e.g. sets, maps, ordered lists, counters, etc
  automatically resolve conflicts
- *Mergeable persistent data structures*
  like Git, and use three-way merge function
  CRDTs use two-way merges
- *Operational transformation* 
  Conflict resolution algorithm behind collaborative editing applications such as Google Docs 
  Concurrent editing of an ordered list of items (such as the list of characters that constitute a text document)

**What is a conflict?**

Some inobvious conflicts:

Two different people booked the same room at the same time.

The application need to ensure one room booked by one group at one time. Even application checks availability before writes, it can still happen on two leaders.

#### Multi-Leader Replication Topologies

In what senquence leader sends to other leader

- All-to-all topology
- Star topology 
  one root node forwards writes
- Circular topology
  All node need to forward writes
  Need to prevent infinite loop

Problem with Star/circular: single point of failure
More densely connected topology is better since there are other paths

Problem with all-to-all: writes arrives in wrong order
(e.g. UPDATE arrives before INSERT)

Similar to "Consistent Prefix Reads"

Solution:

(NOT WORK) attach timestamp. since clocks CANNOT be trusted in sync

1. *version vectors*

But conflict detectioin are poorly implemented in many multi-leader replication system

### Leaderless Replication

Dynamo-Style

Cassandra, Riak, and Voldemort

（DynamoDB != Dynamo, DynamoDB is still single-leader)

Client sends to several replicas, or sent to coordinator node(doesn't enforce ordering of write)

#### Writing to the Database When a Node Is Down

If leader failed: need failover
But in leaderless system, failover doesn't exist

Quorum write, quorum read, and read repair after a node outage

Deal with stale values: Version number

##### Read repair and anti-entropy

How unavaibale node catches up when it's back?

1. Read repair
   Works well for values with frequent read
2. Anti-entropy process
   Background process
   Different from "replication log" in leader-based replication: this doesn't copy write in particular order. Delay can be huge

##### Quorums for reading and writing

w + r > n

Reads and writes that obey these r and w values are called *quorum* reads and writes

*strict quorum*, to contrast with *sloppy quorums*

There maybe more than n nodes in the cluster, but any given value is stored only on n nodes (partitioned dataset)

Still sent request to all n nodes. Just only wait for partial to report success

#### Limitations of Quorum Consistency

w + r ≤ n

More likely to read stale value
Higher availability

w + r > n can hit stale value too, e.g.

- Sloppy quorum
- Two concurrent writes
- Write concurrent with read (not sure new or old value)
- Succeeded only on partial of w, thuse the write is considered failed. But the read may get the value
- Node with new value fails, restored from an old replica
- Timing “Linearizability and quorums” on page 334

Not easy to guarantee.
Dynamo-style is optimized for use case that can tolerent eventual consistency

w and r adjust the probability of stale value being read

No guarantee of *reading your writes, monotonic reads, or consistent prefixreads*

Stronger guarentee would require transactions or consensus

**Monitoring staleness**

Even you can tolerate stale read, you need monitoring
Huge lag: network or overloaded node

In leader-based: writes apply in same order
Can measure lag by subtracing positions

In leaderless: difficult

Eventual consistency is vague, but still we need to be able to measure it
*staleness measurements*

#### Sloppy Quorums and Hinted Handoff

Network can easily cut off a client from a large number of db

Trade-off:

- Is it better to return error to all requests (for not able to reach quorum)?
- Or should we accept the writes and write to nodes not in the n nodes

Later knowns as *sloppy quorum*

Still w and r, but not necessarily the n "home" node

Once network is fixed, those writes are sent to the appropriate "home"
*hinted handoff*

A sloppy quorum actually isn’t a quorum at all in the traditional sense.
No guarantee read from r nodes will see new value until the hinted handoff has completed.

**Multi-datacenter operation**

Multi-leader, leaderless are both suitable for multi-datacenter operation
Tolerate: conflicting concurrent writes, network issue, latency spikes

*Cassandra and Voldemort*: n in all datacenters, but only wait for quorum in local datacenter

*Riak*: n in local data center. Async cross datacenter

#### Detecting Concurrent Writes

Similar to multi-leader write conflicts, but can happen also in read repair and hinted handoff

**Last write wins** (discarding concurrent writes)

Force an arbitraty order: attach a timestamp

LWW achieves the goal of *eventual convergence*, but *at the cost of durability*

Many writes "succeeded", only one survive, other silently discard

Even drop writes that are not concurrent

LLW is the only supported conflict resolution in Cassandra

When to use LWW:
when lost data is acceptable

How to safely use Cassandra:
ensure a key is only writen once (e.g. use UUID as key)

**The “happens-before” relationship and concurrency**

How to decide whether two operatio concrrent or not?

- UPDATE on a INSERT value: casually dependent
- No causal dependencies

Operation A *happens before* another operation B if B knows about A, or depends on A

Concurrent: neither *happens before* the other

We need an algorithm to tell whether concurrent

Concurrency may seems occur "at the same time". But acutally time doesn't matter, since distributed system, hard to tell whether they happened at the same time.

Physical: (special theory of relativity) in physicsinformation cannot travel faster than speed of light

Computer science:

- Two events happen in short time with long distance: can't affect each other
- Two events happen apart for a long time can still be concurrent, due to network slowness

**Capturing the happens-before relationship**

Two people adding things to shopping cart:

The clients are never fully up to date with the data on the server, since there is always another operation going on concurrently.
But old versions of the value do get overwritten eventually, and no writes are lost.

Algorithm:

- Server maintains a version number for every key
  Store value with version number
- Read: get all values haven't been overwritten, and latest version number.
  Client must read key before write
- Write: must include the version number from prior read, and must merge values
- Server receives write with a version number: can overwrite values <= that version. Keep value with higher version

**Merging concurrently written values**

No data loss

Extra cleanup work: merging *siblings*

Simple case: shopping cart: just take the union

*Remove things*: deletion marker *tombstone*

Since merging is complex and error-prone, CRDT is desgined to auto merge in a sensible way

**Version vectors**

Previous example: single replica

How about multi-replica: single version -> version per replica

version vector



Version vectors != vector clocks
Version vectors: track data in replicas
Vector clocks: track events in processes

### Summary

Replication purpose

- High availability
- Disconnected operation
- Latency (geographic, localize data)
- Scalability

Three main approaches

- Single-leader
  Easy, no conflict
- Multi-leader
- Leaderless

Multi-leader/leaderless: More robust, at the cost of harder to reason about, weak consistency guarantee

Synchronous vs Asynchronous replication
Async: if leader fails, promoting async followers case data lost

Consistencyt models (under replication lag):

- Read-after-write consistency
  See data write by themself
- Monotonic read
  Don't see data older than last seen
- Consistent prefix reads
  Data make causal sense: e.g. not see answer before question

Concurrency and conflict
Whether concurrent is not about time
Resolve conflict by merging

