# Prevent lost updates 
Basic write-write conflict: dirty write. But there are more kinds of conflicts when concurrent writing transactions happen. E.g. lost update


##  lost update 
Happens when read-modify-write cycle happens 
- Increase a counter 
- Update a json file
- Update a wiki page
How to solve: 
- atomic operations 
- Explicit locking the object when r/w: select … for update 
- Automatically detect and abort the offending transaction
- CAS
- Conflict resolution (especially in lead less database)

## write skew and phantoms 
Example: Doctor on-call. Two doctors query current DRI number at the same time to make sure there are at least 2 DRI before marking themselves as absent. 
Two transactions do not modify the same object. But the write operation “modifies” the aggregation result (the count)
