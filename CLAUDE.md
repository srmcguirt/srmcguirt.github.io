# srmcguirt.github.io / srmcguirt.dev (WireForge)

Single source of truth for two published surfaces: the srmcguirt.dev site and
the github.com/srmcguirt profile README. The site is served by the `wireforge`
Cloudflare Worker: static assets in `public/` (index.html, robots.txt,
sitemap.xml) plus `/subscribe` email capture backed by an `EMAILS` KV
namespace (`src/worker.js`, `wrangler.toml`). The profile README lives at
`profile/README.md` and is pushed to the `srmcguirt/srmcguirt` repo — never
edit that repo directly. Publish both with `scripts/publish.sh`; CI does the
same on push to `main` once the `CLOUDFLARE_API_TOKEN` and
`PROFILE_DEPLOY_KEY` secrets exist. `scripts/check-links.sh` must pass before
anything ships. The site sells a three-tier services funnel; the Gumroad
product catalog was retired in September 2026 and must not come back as dead
links. No `package.json` — the Worker is deployed via `npx wrangler`.

## Skill routing

This repo's product *is* its growth/conversion performance, so unlike a
typical dev-tool repo, marketing/SEO/content skills are in scope alongside
the small amount of real infra it now owns (Worker + KV + CI deploy).
Skills come from `rampstack-skills` (`rampstackco/claude-skills`), enabled
repo-level in `.claude/settings.json` so it travels with the repo instead of
only living in a personal `~/.claude/settings.json`.

- Landing page / services-funnel copy changes → `landing-page-copy`
- On-page SEO (meta description, headings, keyword targeting) → `seo-onpage`
- Technical SEO (robots.txt + sitemap.xml exist but are minimal — one URL,
  no per-product entries) → `seo-technical`
- Email-capture conversion work (`/subscribe` is live and wired to a real
  KV store now, not a placeholder) → `cro-optimization`
- Tone/voice consistency across services tiers and urgency
  banners (e.g. the "Stocky Aug 31" banner) → `brand-voice`
- General copy/content edits beyond the landing page → `content-and-copy`
- Accessibility check (public-facing UI) → `accessibility-audit`
- Page-weight/load-speed work → `performance-optimization`
- Secrets handling for the `CLOUDFLARE_API_TOKEN` deploy secret and the
  `/subscribe` endpoint's input validation → `security-baseline`
- The `EMAILS` KV namespace holds real subscriber data with no documented
  export/backup step → `backup-and-disaster-recovery`

**Excluded, with reason** (don't add these back without a real trigger):
- `dependency-management` — no `package.json`/lockfile; wrangler runs via
  `npx`, nothing pinned to manage yet.
- `monitoring-and-alerting`, `incident-response` — the Worker is simple
  (static assets + one POST endpoint) and low-traffic; revisit if the
  services funnel starts driving real paid-lead volume through it.
- `cost-optimization` — Cloudflare Workers + KV free tier comfortably
  covers current traffic; nothing paid to optimize yet.
- `design-standards` / `design-system` — no existing design-system doc to
  defer to, but the page is small enough (one HTML file, CSS tokens in a
  `:root` block) that a formal doc would be overhead; revisit if the
  product catalog or services funnel grows substantially.
- `documentation-strategy` — one `README.md` covering deploy + structure is
  sufficient for a single-maintainer static site; no docs tree to organize.

No `AGENT-HANDOVER.md` or equivalent multi-agent coordination doc exists in
this repo — none was created by this onboarding pass. If one gets added
later, this section should be adapted to reference it.
