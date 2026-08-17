// WireForge worker — serves static assets + email capture.
// Fixes vs previous deploy:
//   1. ASSETS.fetch wrapped in try/catch — unknown paths now 404 instead of 500
//      (the old worker returned 500 on /robots.txt, /favicon.ico, etc.,
//      which blocked search crawlers entirely).
//   2. robots.txt + sitemap.xml now ship as real assets in public/.

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // Short redirects
    if (url.pathname === '/github') {
      return Response.redirect('https://github.com/srmcguirt', 302);
    }
    if (url.pathname === '/gumroad') {
      return Response.redirect('https://srmcguirt.gumroad.com', 302);
    }

    // Email capture -> EMAILS KV (key: email, value: ISO timestamp)
    if (url.pathname === '/subscribe' && request.method === 'POST') {
      try {
        const body = await request.json();
        const email = (body.email || '').trim().toLowerCase();
        if (!email || !email.includes('@') || !email.includes('.')) {
          return Response.json({ ok: false, error: 'Invalid email' }, { status: 400 });
        }
        const ts = new Date().toISOString();
        await env.EMAILS.put(email, ts);
        return Response.json(
          { ok: true },
          { status: 200, headers: { 'Access-Control-Allow-Origin': '*' } }
        );
      } catch (err) {
        return Response.json({ ok: false, error: 'Bad request' }, { status: 400 });
      }
    }

    // CORS preflight for /subscribe
    if (url.pathname === '/subscribe' && request.method === 'OPTIONS') {
      return new Response(null, {
        status: 204,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type'
        }
      });
    }

    // Static assets — never let an assets error surface as a 500
    try {
      const res = await env.ASSETS.fetch(request);
      if (res.status !== 404) return res;
    } catch (err) {
      // fall through to 404 below
    }
    return new Response('Not found', {
      status: 404,
      headers: { 'Content-Type': 'text/plain' }
    });
  }
};
