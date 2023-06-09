P99-P103

#### Sort Order in Column Storage

Can't sort each column independently.

e.g. date as first sort key, product id as second sort key

Advantages:

1. Optimize the query (no need to scan all)
2. help with compression (run-length compression)
   Compression effect is strongest on the first sort key

**Several different sort orders**

Data needs to be replicated anyway, why not sort in different ways?

Like having multiple secondary indexes in a row-oriented store. But：

- Row-oriented store： secondary indexes are just pointers. Rows are in one place
- Column store: not pointer, but actual values

#### Writing to Column-Oriented Storage

Compressed column: an insertion has to update all columns files consistently

Solution: LSM-trees. Im-memory store, and write in bulk

And query need to examine both recent write in memory and column data on disk

#### Aggregation: Data Cubes and Materialized Views

*materialized aggregates.*

If aggregate functions (COUNT, SUM, AVE, MAX, MIN) are used many times, why not cache them?

One way: ***materialized view***

materialized view: actual copy of result, written to disk
virtual view: shortcut for queries

update of *materialized view*:
Can be automatic but make writes slower, thus not in OLTP

 ***data cube*** or *OLAP cube*

E.g. assume the fact table have two dimension tables, date and product.
Then the cube can have

1. sum for each product on each date.
2.  (reduce by one dimention) all product on one date, all date on one product

In general, facts often have more than two dimensions.

Pros: certain query can be very fast
Cons: not flexible, i.e. adding a fillter "sales from items with price > $100"
