# Faults and partial failures

Single computer: deterministic, crash-stop model

Distributed system: non-deterministic, partial failures

- Some parts are working fine, some are failed
- Some operations can succeed, some are not
- It’s wise to assume that every component may fail at any time

## Unreliable Network

Distributed system is based on **shared-nothing** architecture. Each component has its own CPU/memory/disk and communicates with each other via network.

Async packet network

- unordered
- packet loss (before/after processing)
- long delay

Network issue is unavoidable. Hardware/software/human operator errors are every where so even redundancy cannot help. We need to be careful with our system to minimize the blast radius.
