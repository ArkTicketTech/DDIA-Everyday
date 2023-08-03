
##### More examples of write skew

*Meeting room booking system*
Want to avoid double-booking
But snapshot isolation can not prevent conflict

*Multiplayer game*
Lock can prevent players move same figure, but can not prevent they move two figures to save position on the board

*Claiming a username*
Snapshot isolation is not safe
But unique constrain would work (the second transaction will be aborted)

*Preventing double-spending*
User don't spend more point than they have
Add item to user's account and check value is positive
But with write skew, maybe two items added and balance is negative

##### Phantoms causing write skew

Pattern

1. SELECT query: search rows that matches certain condition
2. Depending on result, application code decides next step
3. Make a write (INSERT, UPDATE, DELETE)
   But this write changes the precondition of decision of step 2

Alternative: write -> select -> commit

Why not lock?
On call doctor case: yes we can lock the row (SELECT FOR UPDATE)
Other case: they check for the *absence* of the row thus nothing to lock

This calls a *phantom*

Snapshot isolation: 
Can avoid phantoms in read-only queries
In read-write transaction, can lead to write skew

##### Materializing conflicts

Artificially introduce object to lock

e.g. meeting room: add 15min time period items. (created rows for next 6-month)

This table is not used to store information, purely for locking and concurrency issue

It's hard to figure out how to materialize
And it's ugly to leak concurrency logic to application code

Serializable isolation level is much preferable in most cases
