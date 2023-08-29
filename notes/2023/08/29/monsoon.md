  # Fault-Tolerant Consensus

## Intro

Consensus: can be used to solve data race: book airplane seat

- Nodes propose values
- Consensus algo determines the final result

How to make it fault-tolerant?

- If leader fails, should elect a new leader (no single dictator)
- No split brain in case of network partition — only one leader

Consensus == Total Order Broadcast

- Each message delivery is a consensus process
- Each consensus result is a delivered message

Examples: ViewStamped Replication, Raft, Paxos, Zab

- A lot of similarity
- Difficult to implement. Don’t reinvent the wheels

## Epoch Number and Quorums

Used to make sure exact one leader

- Could be more, but should have different epoch(term) number
- With each term, the uniqueness of leadership is gurarnteed

Vote starts if leader is “dead” with new term

Leader is decided by majority. There is ONLY ONE majority in a quorum

Each node can vote ONLY ONCE for each term

## Limitations of consensus

- Performance: every consensus requires string majority
- Dynamic membership is difficult to implement and understand
- Timeout threshold is difficult to set
    - too small → frequent election
    - too big → more waiting time
- Sensitive to network problems
    - Raft: if the network link is unstable, then a node may start voting frequently, causing frequent election
