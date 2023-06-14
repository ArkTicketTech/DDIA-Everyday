P115 - P121

**JSON Binary encoding**

JSON binary encoding: no prescribe schema, very small space reduction. Not worth loss of human-readability



#### Thrift and Protocol Buffers

Both require a schema

Thrift: *BinaryProtocol* and *CompactProtocol*

type + field tag + length indication + data

CompactProtocol:

- one byte for field type and tag number
- Smaller integer use less bytes

Required and optional: they make no diff on encoding. Only "required" enables a runtime check.

**Schema Evolution**

1. Field tags
   - Free to change field name, but can not change field tag
   - Adding new field:
     - Forward compatibility: meets. Old code can ignore (datatype annotation tells it how many bytes to skip)
     - Backward compatibility: new field can not be required. Must be optional or with a default value
   - Removing fields:
     - Can only remove field that is optional
     - Can never reuse the same tag number
2. Datatypes
   - Risk: lose precision or get truncated.
     e.g. 32-bit int to 64-bit int. Old code will truncate the value
   - *Protocol Buffers* doesn't have a list or array data type.
     It's okay to change optional field(single-valued) to repeated field(multi-valued)
     And old code only sees the last element of the list
   - *Thrift*: can't make the above evolution. But has the advantage of supporting nested lists
