# srmcguirt.dev — WireForge

Single source of truth for two published surfaces:

| Surface | Source in this repo | Published by |
|---|---|---|
| [srmcguirt.dev](https://srmcguirt.dev) | `public/` + `src/worker.js` | Cloudflare Worker `wireforge` |
| [github.com/srmcguirt](https://github.com/srmcguirt) profile README | `profile/README.md` | pushed to the `srmcguirt/srmcguirt` repo |

Edit here, publish from here. Never edit the profile repo directly — it gets overwritten.

## Publish

Local (works today with `gh auth login` + `npx wrangler login`):

```bash
scripts/publish.sh          # site + profile
scripts/publish.sh site     # Cloudflare only
scripts/publish.sh profile  # GitHub profile README only
```

CI on push to `main` (each needs one repo secret):

- `deploy.yml` → Cloudflare Workers, needs `CLOUDFLARE_API_TOKEN`
  (Cloudflare dashboard → My Profile → API Tokens → "Edit Cloudflare Workers" template)
- `sync-profile.yml` → profile README, needs `PROFILE_DEPLOY_KEY`
  (private half of a write deploy key registered on `srmcguirt/srmcguirt`)
- `check-links.yml` → fails on any dead outbound link; also runs weekly

```bash
scripts/check-links.sh      # run the link check locally
```

## Structure

- `public/` — static site (index.html, robots.txt, sitemap.xml)
- `profile/README.md` — GitHub profile README
- `src/worker.js` — routing, `/subscribe` email capture (EMAILS KV), 404 handling
- `wrangler.toml` — worker + assets + KV config
- `scripts/` — `publish.sh`, `check-links.sh`
