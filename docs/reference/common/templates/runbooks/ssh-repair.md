> Source-of-truth: `verkis-lab/proxmox-manager:/runbooks/ssh-repair.md` on host `3HS`. NAS copy synced 2026-05-28.

# Runbook: SSH Access Repair

## Identify
- Target host/VM/LXC, username, expected public key, current access path (console available?).

## Inspect (read-only first)
```bash
getent passwd USER
ls -ld ~USER ~USER/.ssh; ls -l ~USER/.ssh/authorized_keys
sshd -T | grep -Ei 'permitrootlogin|passwordauthentication|pubkeyauthentication|allowusers|denyusers'
systemctl status ssh; journalctl -u ssh -n 50 --no-pager
```

## Fix (back up before editing)
- **Never blindly overwrite** `authorized_keys` — append, don't replace.
- Backup config: `cp -a /etc/ssh/sshd_config /etc/ssh/sshd_config.$(date +%F).bak`.
- Fix perms: `chmod 700 ~USER/.ssh; chmod 600 ~USER/.ssh/authorized_keys; chown -R USER: ~USER/.ssh`.
- After editing sshd_config: `sshd -t` (syntax) → `systemctl reload ssh` (reload, not restart, when remote).

## Verify
```bash
ssh -vvv -o BatchMode=yes USER@HOST true
```
- Keep an existing session open until the new path is confirmed. Note firewall/fail2ban if relevant.
