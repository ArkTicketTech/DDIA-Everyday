P90-P95

### Transaction Processing or Analytics?

Transaction: low-latency reads and writes - as opposed to *batch processing*

Doesn't have to be ACID (atomicity, consis‐ tency, isolation, and durability)

OLTP: online transaction processing

OLAP: online analytic processing

| --              | OLTP                  | OLAP                 |
| --------------- | --------------------- | -------------------- |
| Read            | small records, by key | large number         |
| Write           | random                | Bulk import / stream |
| Used by         | End user via web app  | Interal analyst      |
| Data represents | Latest state of data  | History              |
| Size            | GB/TB                 | TB/PB                |

#### Data Warehousing

Data Warehouse: A separate database for OLAP

ETL: (Extract–Transform–Load) transformed into an analysis-friendly schema, cleaned up, and then loaded into the data warehouse

Advantage of using data warehouse:

- No harm for performance of OLTP
- Can be optimized for analytic access patterns

**Divergence between OLTP databases and data warehouses**

DB vendors focus on supporting only one, but not both

#### Stars and Snowflakes: Schemas for Analytics

Star schema: fact table + dimentional table

(Even date and time are often represented using dimension tables, because this allows additional information about dates (such as public holidays) to be encoded, allowing queries to differentiate between sales on holidays and non-holidays.)

Snowflake schema: 

Snowflake schemas are more normalized

Star schemas aresimpler to work with
