
### Two-Phase Locking

Locking - prevent dirty writes

Two-phase locking: stronger, as soon as anyone wants to write the object
- If A has read and B wants to write, B must wait till A commits (ensure B don't change behind A's back)
- If A has written and B wants to read, B must wait till A commit (Reading old version is not acceptable under 2PL)

- In 2PL, writers don't just block writers, they also block readers
- (Not like snapshot isolation)

- 2PL provides serializability, protects all race conditions, including lost update and write skew
