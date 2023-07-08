
P219-P224

## Chapter 7. Transactions

Why transaction?
Things can go wrong:

- db failed (software/hardware)
- app crashes
- Interrupted network
- Clients write concurrently
- Client read partially updated data
- Race conditions

*Transaction*: simplify the issue

What is transaction?
"a way for an application to group several reads and writes together into a logical unit" either all succeeded or fails
No partial failure

When to use transaction?
Sometimes abandon for higher performance / availability

#### The Slippery Concept of a Transaction

X Not true to say "transactions were the antithesis of scalability"

X Not true to say "transactional guarantees essential requirement for “serious applications” with “valuable data.”

both are hyperbole

##### The Meaning of ACID

Atomicity, Consistency, Isolation, and Durability.

But "isolation" is pretty ambiguous

**Atomicity**

Can mean different things

In multi-threaded programming:

- Another thread can not see the half-finished result of an atomic operation

In DB: not about concurrency

- Multiple writes, either committed, or aborted and undo

Ensure aborted transaction didn't change anything
Safe to retry
