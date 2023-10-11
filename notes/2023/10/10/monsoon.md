# Storage and Retrieval
- Our db_set function actually has pretty good performance for something that is so simple, because appending to a file is generally very efficient. 
- our db_get function has terrible performance if you have a large number of records in your database.
- we need a different data structure: an index. This is an important trade-off in storage systems: well-chosen indexes speed up read queries, but every index slows down writes. 

# Hash Indexes
