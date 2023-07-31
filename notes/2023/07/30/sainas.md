#### Write Skew and Phantoms

Two on-call doctor, both cancel their shift at same time, no one is on call

##### Characterizing write skew

Not dirty write or lost update

Two transaction are updating two different objects

Generalization:
Two transactions read same objects and then update partial objects

- different object -> *write skew*
- same object -> *dirty write* or *lost update* depending on the timing

Now try use those ways for preventing lost updates and see if they work on write skew

- Atomic: no, it's single object

- Automatic detection: no. Automatically preventing write skew needs true serializable isolation

- DB config constraints: (unique keys, FK) most DB doesn't have multi-object constrains. Maybe can implement with triggers or materialized views

- If can't use serializable isolation, second-best is write a lock:

  ```sql
  BEGIN TRANSACTION; 
  SELECT * FROM doctors WHERE on_call = true AND shift_id = 1234 FOR UPDATE;
  UPDATE doctors SET on_call = false WHERE name = 'Alice' AND shift_id = 1234;
  COMMIT;
  ```

  
