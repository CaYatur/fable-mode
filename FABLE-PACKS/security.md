# FABLE PACK — Security

> Expert-pattern module for Fable Mode. **Load when:** writing/reviewing anything that touches user input, auth, secrets, files, or the network — which is almost everything. **How to use:** run new code against the smell table; apply the per-change checklist before "done" (§9).

## Mindset

Every input is hostile: params, headers, cookies, filenames, webhook payloads, and data re-read from your own database (stored attacks). Default deny; least privilege; defense in depth; fail closed.

## Code smell → vulnerability → fix

| Smell | Vulnerability | Fix |
|---|---|---|
| SQL/shell/LDAP built by string concatenation | injection | parameterized queries / arg arrays — never blacklist-sanitize |
| User data concatenated into HTML | XSS | context-aware escaping (framework defaults), CSP as backstop |
| User-controlled path or filename used in FS ops | path traversal | allowlist names, resolve to absolute, verify prefix |
| Deserializing user data (`pickle`, `eval`, unsafe `yaml.load`, Java native) | remote code execution | safe formats (JSON) + schema validation |
| Object ID from client used without ownership check | IDOR | authorization **per object**, not just per endpoint — authn ≠ authz |
| Server fetches a user-supplied URL | SSRF | allowlist hosts, block private IP ranges & redirects to them |
| Secrets compared with `==` | timing attack | constant-time comparison |
| JWT accepted without checks | token forgery | verify signature with an **algorithm allowlist** (reject `none`), check `exp` and audience |
| Passwords hashed with MD5/SHA-x or unsalted | offline cracking | argon2id or bcrypt, per-password salt |
| Secrets in code, committed env files, logs, URLs, or error messages | credential leak | secret manager/env at runtime; **a leaked secret is rotated, not deleted** — the commit history remembers |

## Web specifics

- Cookies: `Secure` + `HttpOnly` + `SameSite`; session tokens never in URLs.
- CSRF tokens for state-changing browser form posts; CORS is not authentication — it only controls browsers.
- Auth endpoints: rate-limit, constant-time responses, enumeration-safe errors ("invalid credentials" for both wrong user and wrong password).
- File uploads: validate type by content not extension, store outside web root, regenerate filenames, cap size.

## Supply chain & process

- Lockfiles committed; audit dependencies on add; prefer few, boring deps; pin CI actions to hashes.
- Never log tokens, passwords, or raw PII; scrub before shipping logs to third parties.

## Per-change checklist (run at §9 time)

1. New input accepted anywhere? → validated, typed, length-capped?
2. New query/command built? → parameterized?
3. New object access? → per-object authz check present?
4. New secret? → in a manager, absent from code/logs/errors?
5. New outbound fetch of user-influenced URLs? → SSRF-guarded?
6. Failure path leaks internals (stack traces, versions, paths) to the user? → generic message out, details to logs.
