P99-P115

## Chapter 4 Encoding and Evolution

*evolvability*

Data format changes. The application code change often can not happen instantaneously

- Server-side: rolling upgrade
- Client-side: at eh mercy of the user

*Backward compatibility*: Newer code can read data that was written by older code.

*Forward compatibility*: Older code can read data that was written by newer code.

### Formats for Encoding Data

Data representation:

1. In memory: objects, structs (access by CPU by pointer)
2. Send data: self-contained sequence of bytes (no pointer)

1 to 2: *encoding ( serialization or marshalling),*

2 to 1: *decoding  (parsing, deserialization, unmarshalling)*

#### Language-Specific Formats

 Java: java.io.Serializable. Third-party: Kryo
Ruby: Marshal
Python: pickle

Pros: 

- convenient

Problems:

- tied to programming language. 
  You can't change language
  Different to Integrate with others that use different language
- Security problem: decoding will instantiate arbitrary classes
  Hacker can make it executes malicious code
- Versioning
  They are for quick and easy encoding. Neglect forward and backward compatibility
- Efficiency 
  (CPU time, size of the encoded structure)
  Java's built-in serialization is notorious for its bad performance and bloated encoding

#### JSON, XML, and Binary Variants

JSON, XML, and CSV are textual formats, somewhat human-readable

Problems:

- Numbers

  - xml, csv: can not distinguish number and string of number

  - JSON: can not distinguish int and float

  - Large number: 

    int >2^53 can not be represent by double. Thus decoding brings inaccuracy
    Twitter: include Twitter ID in JSON twice, one as number and decimal string

- Doesn't support binary string
  Get around: Base64-encoded
  Hacky and increases data size by 33%
- Schema support
  Correct interpretation depends on schema
  Application need to hardcode it
- CSV
  Value can have comma, newline character

JSON, XML, and CSV

- Good enough for many purposes
- As long as people agree on the format, doesn’t matter how pretty or efficient. 
  (The difficulty of getting different organizations to agree on anything outweighs most other concerns.)

**Binary encoding**

TODO
