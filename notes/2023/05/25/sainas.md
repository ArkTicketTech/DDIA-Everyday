P25-P48


### CHAPTER 2. Data Models and Query Languages
#### Relational Model Versus Document Model
NoSQL: why born? Because scalability / open source over commercial / specialized query / flexible schema and expressive data model

*polyglot persistence*

*impedance mismatch* 

DB <---mismatch---> OOD. ORM (Object-relational mapping) helps reduce

**Example: Resume**
It has many one-to-many relationships
Option 1: traditional SQL model (before1999) separate tables
Option 2: XML or JSON data type; multi values in single row and querying/indexing
Option 3: encoded as XML/JSON but stored in txt (downside: can not use db to query)

This data structure is mostly a self-contained *document*, JSON representation can be quite appropriate, reduces the impedance mismatch

The JSON representation has better locality than the multi-table schema. (One query, no join)
JSON representation makes this tree structure explicit。

#### Many-to-One and Many-to-Many Relationships

Benefits of standardized lists of geographic regions and drop-down list for user

- Consistent. Avoiding ambiguity (e.g.same name)
- Ease of updating. Localization support
- Better search

Stores ID VS Stores text

- Use ID
  human-meaningful information stored in one place. 
  ID doesn't need to change. *"Normalization"*
- Use text:
  human-meaningful information duplicating. 
  All duplicated copies need to be updated
  Risk: write overheads and inconsistencies

Relational DB support joins. Document DB, no need for one-to-many, support for joins is weak

If DB doesn't support, need application supports. (slow-changing, small, can fit into memory) Still the work is shifted from DB to App.

Besides data has a tendency of becoming more interconnected

#### Are Document Databases Repeating History?

*Hierarchical model* -> *relational model* and *network model*

**Network model**

Allows multiple parents. No foreign key. Like pointers in programming language
Only way of accessing record is *access path* (like linked list)

- Flexibility?
  Need to keep track of the access path:
  Change to access path would need updating a lot of queries

**Relational model**

Can read row directly
Query optimizer decides the execution plan (like the access path) but automatically.

- Flexibility?
  If you want to query in new way, only need to add new index and they will be used automatically. Thus easier to add new features

Query optimizers are complicated beasts. But it only need to build once and all who use the database can benefit (harder, but general-purpose solution wins in the long run)

**Comparison to document databases**

Document DB, like hierarchical, stores one-to-many
But for many-to-one and many-to-many, relational and document DB are quite similar, they both use *foreign key* (called *document reference* in document model

#### Relational Versus Document Databases Today

**Which leads to simple application code?**

Document model

Pros

- no shredding (split to multiple tables in relational db)

Cons

- Can't refer directly to nested item (thus better not too deep)
- Poor join (but not needed, e.g. in analytics app)

In many-to-many case, since you can't join, application has to renormalize, and need to keep data consistent, making it more complex and slow.

interconnection

| interconnection | low      | high       | very high |
| --------------- | -------- | ---------- | --------- |
| suggestion      | document | relational | graph     |

**Schema flexibility in the document model**

*No schema. schemaless*. But it's misleading. 

| Document | Relational  |
| --------------- | -------- |
| schema-on-read  | schema-on-write  |
| Like dynamic type checking | Like static type checking |

Schema change is not slow or have downtime: most DB do ALTER TABLE quick, except MySQL copies entire table.

When to use?

- Many different type of objects. Don't want each to be a table
- Structure determined by external system. Can't control the change

**Data locality for queries**

Faster retriving
But need to keep each document small (and not increase)

(For two reasons, 1. db loads the entire document 2. changes rewrite the entire document, unless size not change then it can be in-place)

Relational DB can be localized too (parent table, multi-table index cluster, column-family)

**Convergence of document and relational databases**

Relational supports XML, JSON

Document supports join

#### Query Languages for Data

|                   | imperative query                      | declarative query                                            |
| ----------------- | ------------------------------------- | ------------------------------------------------------------ |
| def               | How to do it step by step             | What's the pattern of the result                             |
| example           | Gremlin                               | SQL, css, cypher                                             |
| Execution         | strictly defined                      | hide execution details: DB can improve without changing the queries |
|                   | Changing ordering may break the query | Order of data is not guaranteed and doesn't matter           |
| Parallelizability | Hard                                  | Easier                                                       |

**Declarative Queries on the Web**

Use css as an example. If it were imperative, besides it;s harder, there are serious problem

1. A little change, the browser should automatically detect it's no longer match the rule, but imperative can not achieve that
2. If you want to use new API that improves performance, you need to rewrite the code. If declarative browser can do it without breaking comparibility

**MapReduce Querying**

MapReduce is neither declarative query nor fully imperative

Restrictions:

- They must be pure functions
  - no database queries
  - no side effects

Thus they can be run in any order, and rerun on failure

Notice: SQL can distribute, MapReduce can single machine. Some SQL can be distributed without using MapReduce. Some SQL DB can run JavaSript function too
