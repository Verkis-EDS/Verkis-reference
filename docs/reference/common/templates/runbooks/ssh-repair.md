# Template: repair SSH access

Owner/date/target: complete before execution. Keep an existing trusted session/console throughout the change.

## Prerequisites and inspection

Identify the account, approved public key, trust record and access path. Inspect account existence, `.ssh` ownership/permissions and effective sshd policy. Do not dump private keys or complete sensitive logs into shared artifacts.

## Steps

Preserve the current authorized keys/configuration privately. Add only the reviewed public key without overwriting existing authorized keys. Correct only the identified owner/permissions. Check `sshd -t` before an approved reload; never use a blind daemon restart as the first diagnostic action.

## Verification

Open a second SSH connection with `BatchMode=yes` and `StrictHostKeyChecking=yes`. Confirm the intended identity and operation before closing the old session. A new host key requires independent verification, not disabling host-key checks.

## Rollback and troubleshooting

Restore the preserved configuration or remove only the newly added key through the retained session/console. Inspect effective policy, permissions, listener, firewall and account restrictions. Keep actual results and owner/date with the completed runbook.
