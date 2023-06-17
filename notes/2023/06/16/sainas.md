P128-P131

### Modes of Dataflow

- Via databases
- Via service calls (REST and RPC)
- Via asynchronous message passing

**Dataflow Through Databases**

More than backward and forward compatibility:

New code writes in, with a new field, old code(doesn't know about new field) reads and updates this record. The new field can be lost.
Desirable behavior is: old code keeps the new field intact, even though it couldn’t be interpreted.

**Different values written at different times**

Same DB have five-year-old data and 5-min-old data

Unlike code deployment replaces all the code

***"Data outlives code"***

Migrating is expensive

Simpler schema change: New column with null default value

Schema evolution: the entire database looks like it was encoded with a single schema, which actually was by various historical versions of the schema.

**Archival storage**

data warehouse

Encoded by latest schema (you are copying the data anyway)

Encode the data in an analytics-friendly column-oriented format such as Parquet
