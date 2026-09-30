# Changes

## 1.0.0 — 2026-09-30 (DIVE-5247)

- `5dive sysadmin` moves out of the core CLI into this plugin. The command, its
  flags, its exit codes and its JSON are unchanged, and so is the seat's one sudoers
  grant (`/usr/local/bin/5dive --json sysadmin _broker`): core execs this plugin's
  `bin/sysadmin` from the root plugin store.
- The body is core's `src/cmd_sysadmin.sh` at `2fa23787` (DIVE-5187), carried
  verbatim; a prelude re-establishes the few core helpers it used.
- New: `5dive sysadmin _bind-pending <profile>` (root only), which core's
  `account set` calls on a box that has the sysadmin seat.
- `tests/sysadmin_unit.sh` carried from core (arms that grade core's own code stay
  in core), plus the plugin-shape arms (l1-l4).
- One behaviour change from core: a non-root caller with no sudo grant for the
  broker used to get sudo's "a password is required" and rc 1 with nothing on
  stdout. It now gets a permission refusal (code 10, and the JSON envelope under
  `--json`); `sudo -n -l` checks the grant without running anything.
