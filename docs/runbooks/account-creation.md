# Runbook: Account Creation

Use this when a new player needs an account on the server.
All commands run in the mangosd console. See [console-access.md](console-access.md) for attach/detach procedure.

## Every new account needs three commands

Replace `<username>` and `<password>` with the player's chosen credentials.
Usernames and passwords are case-insensitive.

```
account create <username> <password>
account set gmlevel <username> 0 -1
account set addon <username> 1
```

- `gmlevel 0` — normal player, no GM privileges. Use `3` only for admins.
- `addon 1` — grants TBC expansion access. Required or the client will be blocked at login.

## Verify it worked

Check in HeidiSQL: `tbcrealmd` → `account` table. Confirm the row exists with `gmlevel = 0` and `expansion = 1`.

## Then tell the player

- Server address: `100.78.207.105`
- Port: `3724`
- Their username and password
- Direct them to the getting started doc for realmlist and client setup

## GM level reference

| Level | Use case |
|-------|----------|
| 0 | Normal player |
| 1 | Moderator |
| 2 | GM |
| 3 | Full admin (console only) |

## Notes

- Do not share admin (level 3) credentials with players.
- If a player cannot log in after account creation, confirm `account set addon <username> 1` was run — missing expansion access is the most common cause.
- Accounts live in `tbcrealmd.account`. Visible in HeidiSQL if you need to audit.
- To delete an account: `account delete <username>` from the console (SEC_CONSOLE command, same access level as create).