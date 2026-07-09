# FABLE PACK — Data & SQL

> Expert-pattern module for Fable Mode. **Load when:** queries, schemas, migrations, ORMs, or any "why is this query slow/wrong/duplicated". **How to use:** check the traps tables before writing or blaming the database — most SQL bugs are one of these.

## NULL traps (three-valued logic)

- `NULL = NULL` is not true — comparisons with NULL yield UNKNOWN; use `IS NULL` / `IS DISTINCT FROM`.
- `WHERE col != 'x'` silently drops rows where `col IS NULL` — the most common "missing rows" bug.
- `NOT IN (subquery)` returns nothing if the subquery contains a single NULL — use `NOT EXISTS`.
- `COUNT(col)` skips NULLs; `COUNT(*)` doesn't — know which you mean.
- Unique indexes typically allow multiple NULLs (dialect-dependent) — don't rely on them to dedupe nullable columns.

## Index rules

- A composite index `(a, b, c)` serves only leftmost prefixes: `a`, `a,b`, `a,b,c` — not `b` alone.
- A function or cast on the column kills index use: `WHERE DATE(created_at) = '2026-07-07'` → rewrite as a range (`>= day AND < day+1`).
- Leading-wildcard `LIKE '%term'` cannot use a btree index.
- Every foreign key you JOIN or filter on deserves an index — and every extra index taxes writes; add deliberately.
- A covering index (includes all selected columns) skips the table lookup entirely — the cheapest big win for hot read queries.

## Query smells

| Smell | Problem | Fix |
|---|---|---|
| `SELECT *` | over-fetch, breaks covering indexes, fragile to schema change | name the columns |
| `OFFSET 10000` pagination | cost grows linearly with offset | keyset: `WHERE id > :last ORDER BY id LIMIT n` |
| `DISTINCT` fixing duplicates | usually papering over join fanout | fix the join/cardinality |
| Implicit type cast in WHERE (string vs int id) | index skipped, silent scans | match types |
| `OR` across different columns | often prevents index use | split into `UNION` of indexed queries |

## Transactions & concurrency

- Keep transactions short — long ones hold locks and block cleanup (vacuum/purge), bloating everything.
- Deadlocks: acquire locks in a consistent global order; retry on deadlock is legitimate (it's the DB choosing a victim).
- Know your isolation default (usually READ COMMITTED): two reads in one transaction may see different data — don't assume repeatable reads.
- Check-then-insert is a race: the unique constraint is the source of truth; the application check is only a courtesy. Insert and handle the violation.
- Money: integer cents or DECIMAL — never float. Timestamps: UTC in storage, timezone at the edge.

## ORM realities

- N+1 is the default ORM behavior — for every list endpoint, inspect the generated SQL (one query per row in a loop is the tell; see performance pack).
- Bulk operations often bypass model hooks/validations — know whether you need them.
- Lazy loading inside a serializer/template loop is the classic hidden N+1.

## Reading EXPLAIN (the 20% that matters)

- Sequential scan on a large table + a selective filter → index candidate.
- Estimated rows vs actual off by 100× → stale statistics (run ANALYZE) — the planner is flying blind.
- Nested loop join over two large sets → missing join index.

## Operations

- Connection pool size ≈ cores × 2–4, not hundreds — beyond that, more connections make everything slower (contention).
- Migrations on live tables: expand → migrate → contract (see architecture pack); create indexes CONCURRENTLY/online; adding a NOT NULL column with a default can lock — check your engine version's behavior first.
- Constraints (unique, FK, CHECK) live in the database — application-only validation is a race condition with a delay.
