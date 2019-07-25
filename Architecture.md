# Architecture
* Last update: July 25, 2019
* This is a living document. Please update this whenever you can.
* This is not 100% complete, the intention is to give you an overview of the system

## Models
### User
```
has_many :subscriptions
```

### Subscription
```
code: string
status: integer # enum

cached_metadata: json
cached_transaction_details: json
```
