P230-P233

**The need for multi-object transactions**

Do we need multi-object transactions at all?

Cases:

- Foreign key
  Ensure valid
- Document db (denormalized)
  often single object.
  Can't join -> denormalized
  When denormalized data updated, ensure all related document are updated in one go
- Secondary index
  Avoid record in one index not in another

**Handling errors and aborts**

ACID -> drop partial result
Leaderless -> best effort

How to retry aborted transaction

- Network issue, retry would execute twice

- Overload. Make things worse
  Solution: exponential backoff, or handle overload error differently

- If not transient error like constraint violation, not worth retry

- Side effect: e.g. sending email
  Solution to coordinate several system in transaction: Two-phase commit

- Client process fails, data lost

  

#### Weak Isolation Levels

Serializable isolation: make developing easy, but have performance cost

Many databases only supports *weaker levels of isolation*

They can only prevent *some* concurrency issue

Concurrency bugs caused by  *weaker levels of isolation*:
e.g.“Use an ACID database if you’re handling financial data!”
This is wrong because many popular relational database systems are "ACID" but use weak isolation which is not enough
