- JSON vs. Relational Model
   * better locality
   * one-to-many relationships fits the tree structure of JSON

 - ID or Text String?
   * duplication of human-readable info
   * human cannot read ID so it needn't change
   * additional write overheads and inconsistency risks

 - Many-to-one relationship
   * many-to-one doesn't fit document model
   * weak support for joins in document databases
   * documents models is suitable for one-to-many, but not many-to-one and many-to-many

 - Network Model
   * each record can have multiple parents
   * links are not foreign keys but more like pointers
   * access path: the path from root to some certain record
   * access path is like the traversal of a linked list in the simplest case.
   * the application code needs to deal with all the various relationships
   * QO can automatically choose execution plan in relational model
   * document model leverages nested records, but use a foreign key for many-to-one and many-to-many like relational models

 - Document model: Simple application code?
   * if document-like, use document model
   * shouldn't be too deeply nested (access path problems in hierarchical model)
   * poor support for joins
