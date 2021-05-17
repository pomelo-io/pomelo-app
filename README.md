# 🍈 Pomelo - EOSIO Smart Contract

## Quickstart

```bash
# donate Pomelo grant
$ cleos transfer myaccount pomelo "1.0000 EOS" "grant:myproject"

# fund Pomelo bounty
$ cleos transfer myaccount pomelo "1.0000 EOS" "bounty:mywork"
```

## Definitions

### Roles

| `role`        | `description`                 |
|---------------|-------------------------------|
| Backend       | Pomelo Backend                |
| Admin         | Pomelo Admins                 |
| Owners        | Grant/Bounty Owners           |
| SC            | Smart Contract                |


## SPECIFICATION

- [ ] Users
- [ ] Social
- [ ] Grants
- [ ] Bounties
- [ ] Donations
- [ ] Restrictions
- [ ] Matching

## Table of Content

- [TABLE `users`](#table-users)
- [TABLE `grants`](#table-grants)
- [TABLE `bounties`](#table-bounties)
- [TABLE `rounds`](#table-rounds)
- [ACTION `userstatus`](#action-userstatus)
- [ACTION `deluser`](#action-deluser)

## TABLE `users`

### multi-indexes

| `param`        | `index_position` | `key_type` |
|--------------- |------------------|------------|
| `byaccount`    | 2                | i64        |
| `bystatus`     | 3                | i64        |
| `byupdated`    | 4                | i64        |

### params

- `{uint64_t} user_id` - (primary key) user ID
- `{name} [eos_account=""]` - EOS account name
- `{name} [region=""]` - user region (ex: `ca`)
- `{map<name, bool>} [social=[]]` - social accounts enabled
- `{name} [status="pending"]` - user status (ex: `pending/ok/disabled`)
- `{time_point_sec} created_at` - created at time
- `{time_point_sec} updated_at` - updated at time
- `{time_point_sec} deleted_at` - deleted at time

### example

```json
{
    "user_id": 123,
    "eos_account": "myaccount",
    "region": "ca",
    "social": [{"key": "github", "value": true}],
    "status": "ok",
    "created_at": "2020-12-06T00:00:00",
    "updated_at": "2020-12-06T00:00:00",
    "deleted_at": "1970-01-01T00:00:00"
}
```

## TABLE `grants` & `bounties`

### multi-indexes

| `param`        | `index_position` | `key_type` |
|--------------- |------------------|------------|
| `byname`       | 2                | i64        |
| `byauthor`     | 3                | i64        |
| `bystatus`     | 4                | i64        |
| `byupdated`    | 5                | i64        |

### params

- `{uint64_t} id` - (primary key) project ID
- `{name} project_name` - (❗️**IMMUTABLE**) project name (used in memo to receive funds, must be unique)
- `{name} category` - (❗️**IMMUTABLE**) project category (ex: `grant/bounty`)
- `{name} author_user_id` - (❗️**IMMUTABLE**) author (Pomelo User Id)
- `{set<name>} [authorized_user_ids=[]]` - authorized admins (Pomelo User Id)
- `{name} [funding_account=""]` - funding account (EOS account)
- `{set<extended_symbol>} [accepted_tokens=["4,EOS@eosio.token"]]` - accepted tokens (ex: `EOS/USDT`)
- `{name} [status="pending"]` - status (`pending/ok/disabled`)
- `{time_point_sec} created_at` - created at time
- `{time_point_sec} updated_at` - updated at time
- `{time_point_sec} deleted_at` - deleted at time

### example

```json
{
    "id": 345,
    "name": "mygrant",
    "category": "grant",
    "author_user_id": 123,
    "authorized_user_ids": [123],
    "funding_account": "myreceiver",
    "accepted_tokens": [{"contract": "eosio.token", "symbol": "4,EOS"}],
    "status": "ok",
    "created_at": "2020-12-06T00:00:00",
    "updated_at": "2020-12-06T00:00:00",
    "deleted_at": "1970-01-01T00:00:00"
}
```

## TABLE `rounds`

### params

- `{uint64_t} round` - (primary key) matching rounds
- `{set<name>} grant_ids` - grants IDs participating
- `{set<name>} user_ids` - user IDs participating
- `{vector<extended_asset>} accepted_tokens` - accepted tokens
- `{time_point_sec} start_at` - start at time
- `{time_point_sec} end_at` - end at time
- `{time_point_sec} created_at` - created at time
- `{time_point_sec} updated_at` - updated at time
- `{time_point_sec} deleted_at` - deleted at time

### example

```json
{
    "round": 1,
    "grant_ids": [345],
    "user_ids": [123],
    "accepted_tokens": [{"contract": "eosio.token", "quantity": "1.0000 EOS"}],
    "start_at": "2020-12-06T00:00:00",
    "end_at": "2020-12-12T00:00:00",
    "created_at": "2020-12-06T00:00:00",
    "updated_at": "2020-12-06T00:00:00",
    "deleted_at": "1970-01-01T00:00:00"
}
```

## TABLE `donate.user`

- scope: `round`

### multi-indexes

| `param`        | `index_position` | `key_type` |
|--------------- |------------------|------------|
| `byaccount`    | 2                | i64        |
| `bygrant`      | 3                | i64        |
| `byvalue`      | 4                | i64        |
| `byupdated`    | 5                | i64        |

### params

- `{uint64_t} id` - (primary key) donate ID
- `{name} eos_account` - EOS account name
- `{uint64_t} round` - participating round
- `{uint64_t} grant_id` - grant ID
- `{extended_asset} amount` - amount of tokens donated
- `{double} value` - USD valuation at time of received
- `{checksum256} trx_id` - transaction ID
- `{time_point_sec} created_at` - created at time
- `{time_point_sec} updated_at` - updated at time

### example

```json
{
    "id": 1001,
    "eos_account": "myaccount",
    "round": 1,
    "grant_id": 123,
    "amount": {"contract": "eosio.token", "quantity": "15.0000 EOS"},
    "value": 100,
    "trx_id": "3bf31f6c32a8663bf3fdb0993a2bf3784d181dc879545603dca2046f05e0c9e1",
    "created_at": "2020-12-06T00:00:00",
    "updated_at": "2020-12-06T00:00:00"
}
```

## TABLE `donate.grant`

- scope: `round`

### multi-indexes

| `param`        | `index_position` | `key_type` |
|--------------- |------------------|------------|
| `byusers`      | 2                | i64        |
| `byvalue`      | 3                | i64        |
| `bymatch`      | 4                | i64        |

### params

- `{uint64_t} grant_id` - (primary key) grant ID
- `{map<name, double>} user_value` - user value contributions
- `{map<name, double>} user_match` - user match contributions
- `{map<name, double>} user_sqrt` - user sqrt contributions (quadratic funding metric)
- `{uint64_t} total_users` - total number of users
- `{double} sum_value` - sum of all user value contributions
- `{double} sum_match` - sum of all user match contributions
- `{double} sum_sqrt` - sum of square root of contributions (quadratic funding metric)
- `{double} square` - total square of the square roots (quadratic funding metric)
- `{time_point_sec} updated_at` - updated at time

### example

```json
{
    "grant_id": 123,
    "user_value": [{ "key": "account1", "value": 100.0 }, { "key": "account2", "value": 50.0 }],
    "user_match": [{ "key": "account1", "value": 225.0 }, { "key": "account2", "value": 100.0 }],
    "user_sqrt":  [{ "key": "account1", "value": 15.0 }, { "key": "account2", "value": 10.0 }],
    "total_users": 2,
    "sum_value": 150.0,
    "sum_match": 325.0,
    "sum_sqrt": 25.0,
    "square": 625.0,
    "updated_at": "2020-12-06T00:00:00"
}
```

## ACTION `setuser`

- **authority**: `get_self()`

### params

- `{uint64_t} user_id` - user ID
- `{name} eos_account` - EOS account name
- `{map<name, bool>} social` - social enabled

### Example

```bash
$ cleos push action pomelo setuser '[123, "myaccount", [{"key": "github", "value": true}]]' -p pomelo
```

## ACTION `userstatus`

- **authority**: `get_self()`

### params

- `{uint64_t} user_id` - user ID
- `{name} status` - status (pending/ok/disabled/delete)

### Example

```bash
$ cleos push action pomelo userstatus '[123, "ok"]' -p pomelo
```
