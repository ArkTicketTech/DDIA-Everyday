# Encoding and Evolution
   ## Formats for Encoding Data
   * Encoding/Serialization/Marshalling: in memory representation -> byte seq
   * Decoding/Deserialization/Unmarshalling: the reverse

   ## Language-Specific Formats
   * Many languages have internal encoding libraries
   * Problems:
      * cannot transform across different languages
      * security issues
      * Lack of versioning
      * Efficiency (Java's built-in serialization)

   ## JSON, XML and Binary Variants
   * Human-readable formats (JSON, XML, CSV)
     * ambiguity
       * XML/CSV: string or number?
       * JSON: int or float? precision?
     * JSON/XML: no support for binary strings
     * JSON/XML: optional schema
     * CSV: vague definition

   ### Binary Coding

   ## Thrift and Protocol Buffers
   * Both need schema
   * Code gen tool: schema -> class in different languages
