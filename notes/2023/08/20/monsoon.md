  # Ordering Guarantees

# Causality and Orders

Causality: cause comes before the effect

Partial order and total order:

- Linearizability: we have total order of each operation. No concurrency
- Causality: we only have partial order (happens-before relationship)

# Linearizability implies Causality

because operations take effect at a “single time point” if linearizability

For example, in the web server and image resizer system, if the web server gets success from the file storage, then any reads from the image resizer will return the file.

## linarizability has bad perf if network latency is unpredictable

In many cases, systems that appear to require linearizability in fact only really require causal consistency, which can be implemented more efficiently.

## capture causal dependencies

core: system needs to maintain happened-before relationship between operations and processes them based on it.

# Sequence Number Ordering

Explicitly keeping track of all causality relationships between many read/write is not practical

But we can use implicit way to do it: sequence number ordering

Sequence numbers are more compact, so less overhead (a few bytes), and provide **total order**

Sequence numbers in a total order that is *consistent with causality*

- If A happened before B, then seqA < seqB

## single leader replication

the order of replication logs can be used as causality

## other cases

for example, multi-leader replication / leadless replication

we can use **Lamport Timestamp**

very old ideas, widely used
