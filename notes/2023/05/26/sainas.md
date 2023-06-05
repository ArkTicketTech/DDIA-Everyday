P48-55

#### Graph-Like Data Models

Use cases: social network, web network, road or rail networks

Algorithms: shortest path, PageRank for web graph

Types

- *property graph* model (Neo4j, Titan)
- *triple-store* model (Datomic, AllegroGraph)

##### Property Graphs

- Vertex: UID, outgoing edge, incoming edge, properties (K-V pairs)
- Edge: UID, tail vertex, head vertex, relationship, properties (K-V pairs)

Can be represented in a relational schema

Good flexibility. for example:
France uses region US use states
Different granularity, when an item sometime specified as city, sometime as states

##### The Cypher Query Language

Declarative

Executing plan can be various

##### Graph Queries in SQL

Can we query graph like SQL? Yes but difficult

Because the number of joins is not fixed. You don't know which table to join in advance

(SQL: use WITH RECURSIVE, 29 lines, Cypher: 4 lines)
