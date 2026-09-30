# 5dive-partner

The partner-box plugin for [5dive](https://5dive.ai). Today it carries one verb,
`5dive sysadmin`: a box's privileged work, where every system change waits for the
client's tap.

It is installed by the **partner box profile only**. A regular 5dive box does not
carry it, so it has no sysadmin seat, no broker grant and no `sysadmin` verb.

```bash
sudo 5dive plugin add 5dive-ai/5dive-partner
sudo 5dive sysadmin install [--auth-profile=<name>]
```

Needs a core CLI that no longer has `sysadmin` built in (the release that removes
it). An older core refuses the install because the verb is already a core command.

## What `sysadmin` does

A persona agent on a partner box is a standard seat: no sudo. One seat, `sysadmin`,
does the privileged work for the others, and its **only** root grant is
`5dive sysadmin _broker`, with exact arguments and parameters on stdin. The broker
enforces every rule:

| verb | who | what |
|---|---|---|
| `read` | the sysadmin seat | a read-only script, run now as `nobody` with the log groups |
| `restart <agent>` | the sysadmin seat | restarts that agent's own service; the one change with no tap |
| `propose --for=<agent> --summary=…` | the sysadmin seat | a root script. 5dive-api sends the client Approve / Decline on the partner's own bot. Nothing runs first |
| `status [<sa-id>]` | the sysadmin seat | a request's state, script and output |
| `answer <sa-id> approve\|decline --sha=…` | root (5dive-api over the tunnel) | the client's tap. Runs the shown script in a root sandbox, once, within 30 minutes |
| `install [--auth-profile=…]` | root (5dive-api at box build) | creates the seat, its broker grant and its rules |

An approved script runs as root with the box's secrets hidden (`/etc/5dive`,
`/var/lib/5dive`, every home), sudoers hidden, the firewall and sshd config
read-only, and no `CAP_SYS_ADMIN`, `CAP_SYS_PTRACE` or `CAP_NET_ADMIN`. A lint
refuses a script that names any of those before the client is ever asked. The
sandbox cannot stop a system service or cron job that the script installs from
running later, outside it. The lint and the client's tap are the controls there.

## Root safety

Core runs this plugin's `bin/sysadmin` as root through the seat's grant, so anyone
who can write that file is root on the box. It lives in the root plugin store
(`/var/lib/5dive/plugins/cache/5dive-partner/partner/<version>/`), root-owned and not
writable by any seat, the same store browser and voice run from.

## Tests

```bash
bash tests/sysadmin_unit.sh      # no root, no network; arm k needs root + systemd
```
