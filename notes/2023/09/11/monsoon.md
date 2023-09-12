# Digital Wallet
### Functional requirements:
- Support balance transfer operations between two digital wallets
- Support Transactions
- Support reproducibility: we could always reconstruct historical balance by replaying the data from the very beginning.

### NOn-functional requirements:
- Correctness: it is only verifiable after teh transaction is complete. One way to verify is to compare our internal records with statement from banks. The limitation of reconciliation is that it only shows discrepancies and cannot tell how a difference was generated.
- Availability: 99.99%
- Support 1M TPS
