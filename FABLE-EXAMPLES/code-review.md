# FABLE EXAMPLE — A Code Review

> Gold-standard worked example of the code-quality pack applied: severity-ordered findings, concrete failure scenarios, and an explicit "what I checked" close. Imitate the shape.

## The diff under review

```js
// GET /api/documents/:id — return a document for the logged-in user
router.get("/api/documents/:id", async (req, res) => {
  try {
    const doc = await db.query(
      `SELECT * FROM documents WHERE id = ${req.params.id}`
    );
    if (!doc) res.status(404).send("Not found");
    analytics.track("doc_viewed", { user: req.user.email, doc: req.params.id });
    res.json(doc);
  } catch (e) {
    console.log(e);
  }
});
```

## The review

**[BLOCKER] SQL injection — line 4.** `req.params.id` is interpolated into the SQL string. Failure scenario: `GET /api/documents/1;DROP TABLE documents--` (or a slower `UNION SELECT` to read other tables). Fix: parameterized query — `db.query("SELECT id, title, body FROM documents WHERE id = $1", [req.params.id])`.

**[BLOCKER] Missing authorization (IDOR) — whole handler.** The route checks *who you are* (`req.user`) but never *whether this document is yours*. Failure scenario: any logged-in user iterates `/api/documents/1..N` and reads everyone's documents. Fix: `WHERE id = $1 AND owner_id = $2` — authorization must be per-object, not per-endpoint.

**[BLOCKER] Missing `return` after 404 — line 6.** After `res.status(404).send(...)`, execution continues: analytics fires and `res.json(doc)` throws "headers already sent". Failure scenario: every request for a missing id logs a crash and pollutes analytics with phantom views. Fix: `return res.status(404)...`.

**[SHOULD-FIX] Swallowed error — catch block.** `console.log(e)` and then… nothing: the client hangs until timeout with no response, and there's no alerting. Fix: log with request context and respond — `res.status(500).json({ error: "internal" })` (generic message out, details to logs — security pack §6).

**[SHOULD-FIX] `SELECT *` — line 4.** Returns every column, today and after the next migration adds `internal_notes`. Failure scenario: a future column leaks to the client the day it's created. Name the columns.

**[NIT] Analytics in the request path.** `analytics.track` is awaited by nothing and can't fail the request today, but if it ever returns a rejected promise this becomes an unhandled rejection. Fire-and-forget explicitly: `analytics.track(...).catch(() => {})` or queue it.

## The close (what a reviewer owes the author)

Checked and found clean: no N+1 here (single query), id is used only in the query (no path/file use), no secrets touched. Not verifiable from this diff: whether `req.user` can be unset on this route — if the auth middleware is optional, line 8 throws on `req.user.email`; flagging for the author to confirm. Severity order above is the merge order: the two blockers about data access (injection, IDOR) matter more than everything else in this file combined.
