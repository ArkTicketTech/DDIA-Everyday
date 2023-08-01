### Avro
 * two schemas: 
   * Avro IDL for human editing
   * another JSON-like for machines
 * most compact encoding

 ## Modes of Dataflow
 * databases
 * service calls
 * async message passing

 ### Dataflow Thru Databases
 * writer encodes data, reader decodes data
 * necessary for backward compatibility
 * forward compatibility required due to different versions of data and concurrency
 * schema change? previously discussed encoding algorithm can deal with unknow field

 #### Different values written at different times
 * data outlives code
 * schema evolution

 #### Archival storage
 * data dump will use the latest schema
 * data dump is more likely to be immutable
