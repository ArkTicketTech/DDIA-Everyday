# Write Skew and Phantoms

previous write race condtition (dirty writes and lost updates) can be prevented by locks/atomic operations/automatic conflict resolution. But there are more kinds of write conflicts that cannot be solved using the above approaches.

Example: on-call schedule for doctors.

- we have two doctors as on-calls. both of them want to take a rest
- both of them execute a DB transaction: check the number of current oncall, if >2, then mark self as leave.
- in snapshot isolation / read committed … , it’s possible that both transactions pass the “>2” check and continue to write
- and finally, no doctor is oncall!

The root cause is that: the write operation can change the result of previous the read operation. 

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2bd5fa75-adc8-411a-8860-a0ddd1698223/Untitled.png)

Another examples, claiming a username, or meeting room booking system

- characteristics: do a read first, and then if the result meets some conditions (have 2 oncalls/no same username exists/meeting room is free), then do a write. the write will change the previous query result (oncalls -=1/ the username exists/meeting room is booked). and the previous condition/constraint is not satisfied anymore.

This is referred to as **write skew**

This effect, where a write in one transaction changes the result of a search query in
another transaction, is called a phantom

## Characterizing write skew

- It is a generalization of the lost update problem
- Occurs if two transactions read the same objects, and then update some of those objects
- In the special case where different transactions update the same object, you get a dirty write or lost update anomaly
- If you can’t use a serializable isolation level, the second-best option in this case is probably to explicitly lock the rows that the transaction depends on.

## Phantoms

Similar pattern:

- SELECT checks some requirement by searching for rows that match
- Continue based on result of the query
- If continue, application makes a write and commits the transaction.
- The effect of the write changes the step 1 query result. (This is called a phantom)
- Snapshot isolation avoids phantoms in read-only queries.
