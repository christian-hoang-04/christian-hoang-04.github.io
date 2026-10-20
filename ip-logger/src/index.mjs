const RETENTION_MS = 30 * 24 * 60 * 60 * 1000;
const MAX_BODY_BYTES = 1024;

function responseHeaders(origin) {
  return {
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '86400',
    'Cache-Control': 'no-store',
    'Vary': 'Origin'
  };
}

function response(message, status, headers) {
  return new Response(message, { status: status, headers: headers });
}

async function readJsonBody(request) {
  if (!request.body) {
    return { error: 'invalid' };
  }

  const reader = request.body.getReader();
  const chunks = [];
  let byteLength = 0;

  while (true) {
    const result = await reader.read();
    if (result.done) {
      break;
    }

    byteLength += result.value.byteLength;
    if (byteLength > MAX_BODY_BYTES) {
      await reader.cancel();
      return { error: 'too-large' };
    }

    chunks.push(result.value);
  }

  const bytes = new Uint8Array(byteLength);
  let offset = 0;
  chunks.forEach(function (chunk) {
    bytes.set(chunk, offset);
    offset += chunk.byteLength;
  });

  try {
    return { payload: JSON.parse(new TextDecoder().decode(bytes)) };
  } catch (error) {
    return { error: 'invalid' };
  }
}

export default {
  async fetch(request, env) {
    const origin = request.headers.get('Origin');
    if (!origin || origin !== env.ALLOWED_ORIGIN) {
      return response('Forbidden', 403, { 'Cache-Control': 'no-store' });
    }

    const headers = responseHeaders(origin);
    const url = new URL(request.url);
    if (url.pathname !== '/visit') {
      return response('Not found', 404, headers);
    }

    if (request.method === 'OPTIONS') {
      return response(null, 204, headers);
    }

    if (request.method !== 'POST') {
      return response('Method not allowed', 405, headers);
    }

    const contentType = request.headers.get('Content-Type') || '';
    if (!contentType.toLowerCase().startsWith('application/json')) {
      return response('Expected JSON', 415, headers);
    }

    const contentLength = Number(request.headers.get('Content-Length') || 0);
    if (contentLength > MAX_BODY_BYTES) {
      return response('Request too large', 413, headers);
    }

    const body = await readJsonBody(request);
    if (body.error === 'too-large') {
      return response('Request too large', 413, headers);
    }
    if (body.error) {
      return response('Invalid JSON', 400, headers);
    }
    const payload = body.payload;

    if (!payload || typeof payload.path !== 'string' || payload.path.length > 512) {
      return response('Invalid path', 400, headers);
    }

    let pageUrl;
    try {
      pageUrl = new URL(payload.path, env.ALLOWED_ORIGIN);
    } catch (error) {
      return response('Invalid path', 400, headers);
    }

    if (pageUrl.origin !== env.ALLOWED_ORIGIN || !pageUrl.pathname.startsWith('/')) {
      return response('Invalid path', 400, headers);
    }

    const ipAddress = request.headers.get('CF-Connecting-IP');
    if (!ipAddress || ipAddress.length > 64) {
      return response('Visitor IP unavailable', 400, headers);
    }

    try {
      await env.VISITS.prepare(
        'INSERT INTO visits (ip_address, path, visited_at) VALUES (?, ?, ?)'
      ).bind(ipAddress, pageUrl.pathname, new Date().toISOString()).run();
    } catch (error) {
      return response('Could not record visit', 500, headers);
    }

    return response(null, 204, headers);
  },

  async scheduled(controller, env) {
    const cutoff = new Date(controller.scheduledTime - RETENTION_MS).toISOString();
    await env.VISITS.prepare(
      'DELETE FROM visits WHERE visited_at < ?'
    ).bind(cutoff).run();
  }
};
