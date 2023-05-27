P55-P71

#### Triple-Stores and SPARQL

（subject, predicate, object) e.g. (Jim, likes, bananas),

- (lucy, age, 33) like the vertex with property

- (lucy, marriedTo, alain) likes the vertex - edge - vertex

*Turtle format*

**The semantic web and RDF**

Triple-store is independent of the semantic web

"semantic web": website publish info as machine-readable data: Resource Description Framework "RDF". Overhyped in the early 2000s

RDF: use URI to avoid conflicts. 
(Design for combining with someone else’s data, same word “within” may refer to different things)

**The SPARQL query language**

Predates Cypher
RDF doesn’t distinguish between properties and edges but just uses predicates for both

**Graph Databases Compared to the Network Model**

Are Graph DB CODASYL in disguise? No

- CODASYL has schema. Graph doesn't
- CODASYL, only way to reach record was to traverse one path. Graph has UID
- CODASYL children of record is ordered. Graph is not
- CODASYL, all queries were imperative. Graph supports declarative query like Cypher, SPARQL

#### The Foundation: Datalog
Datalog is much older, provides the foundation that later query languages build upon.
*predicate(subject, object)*

Rules, like function calls, can be recursive, can be combined and reused

### Summary

History - hierarchical model

SQL - Relational model

NoSQL

- Document model
- Graph model

But there are still many other data models

- Genome: need sequence similarity searches on very  long string (DNA molecule). Similar but identical. Genome DB like GenBank
- Particle Physicists: Large Hadron Collider (LHC) hundreds of petabytes. Custom solutions are required for controllable hardware cost
- Full-text search

## Chapter 3: Storage and Retrieval

Two families of storage engines: *log-structured* storage engines, and *page-oriented* storage engines such as B-trees.

### Data Structures That Power Your Database

Simplist: key value store with plain text, or value can be JSON

```
123456 '{"name":"London","attractions":["Big Ben","London Eye"]}'
```

(Real database use a *log* too, just with concurrency control and so on. Different from *application log*, this is more general:"append-only sequence of records")

- Good performance on write. Appending file is efficient

- Bad performance on read. O(n)

**Index**

- Additional structure. Doesn’t affect the contents, only affects performance of queries. 
- Incurs overhead, especially on writes. 

Important trade-off

