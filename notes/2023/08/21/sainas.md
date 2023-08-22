#### Predicate locks
Serializable isolation must prevent phantoms

Meeting room booking case: lock one room for time range, but not other room or diff time range

Need condition:

```sql
SELECT * FROM bookings
WHERE room_id = 123
AND end_time > '2018-01-01 12:00'
AND start_time < '2018-01-01 13:00';
```

Predicate lock:
- If A wants to read an object that matches the condition: shared-mode predicate lock
If B holds exclusive lock A must wait
- If A wants to insert/update/delete, it must check if the **old** or **new** value matches the existing predicate lock
If so it must wait

Key: need to check new value that hasn't been inserted

If 2-phase lock includes predicate locks: no any write skew or race condition

#### Index range lock
Predicate lock: perform badly

*Index-range lock* or *next-key lock*: approximation of predicate lock

e.g. room 123 at 1pm ->  room123 all time, or all rooms at 1pm

If index is room id: room 123
If index is time-based: all rooms during that time

More effective.

What if no suitable index? Can fall back to shared lock on the entire table. (Not good performance, but save fallback)
