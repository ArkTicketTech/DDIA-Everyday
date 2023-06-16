P122-P127

#### Avro

Most compact

- Schema: No tag number
- Binary data, no fields or datatypes. Only in schema

Any mismatch in the schema would cause trouble

**The writer’s schema and the reader’s schema**

writer’s schema and reader’s schema don't have to be the same

Can handle: different order, ignore fields, autofill with default value

**Schema evolution rules**

To maintain forward and backward compatibility, only add or remove a field with a default value

Only backward compatible: adding alias for field, add one more union type

**But what is the writer’s schema?**

Usecase:

1. Hadoop: large file with lots of record
2. Database with individually written records
   Version number at the beginning of encoded record, and a list of schema version
3. Sending records over a network connection
   Negotiate the schema version on connection setup

**Dynamically generated schemas**

Advantage of Avro: Friendlier to dynamically generated schemas

No tag numbers. No need manual mapping and avoiding used numbers

**Code generation and dynamically typed languages**

Code generation are more for statically typed languages, not for dynamically typed languages, since they don't have compile-time type checker

For Avro (dynamically generated schema from db table), code generation is unnecessary

Avro container file is self-describing (embeds with writer's schema)


