# Timeouts and Unbounded Delays

Choosing the right timeout for fault detection is a crucial but challenging decision.

- Longer timeouts: delay  detection but reduce the risk of false positives.

- Shorter timeouts: detect faster but can lead to incorrect node declarations.

Prematurely declaring a node dead can cause actions to be duplicated.

Tasks are transferred, adding load to the system ->  worsen issues in high-load system

Ideal timeout calculations depend on guaranteed response times(most systems don't have)

Low timeout:  transient spike in round-trip times to throw the system off-balance.
