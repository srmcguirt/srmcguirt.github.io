# srmcguirt.dev — WireForge

Live site for [srmcguirt.dev](https://srmcguirt.dev), served by the `wireforge`
Cloudflare Worker (static assets in `public/` + email capture at `/subscribe`
backed by the EMAILS KV namespace).

## Deploy

Push to `main` and GitHub Actions deploys via wrangler.
One-time setup: add the `CLOUDFLARE_API_TOKEN` repo secret
(Cloudflare dashboard -> My Profile -> API Tokens -> "Edit Cloudflare Workers" template).

Manual deploy: `npx wrangler deploy`

## Structure

- `public/` — static site (index.html, robots.txt, sitemap.xml)
- `src/worker.js` — routing, /subscribe endpoint, 404 handling
- `wrangler.toml` — worker + assets + KV config
