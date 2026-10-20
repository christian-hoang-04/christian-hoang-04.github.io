(function () {
  const endpoint = window.VISITOR_LOG_ENDPOINT;
  if (typeof endpoint !== 'string' || endpoint.trim() === '') {
    return;
  }

  let endpointUrl;
  try {
    endpointUrl = new URL(endpoint);
  } catch (error) {
    return;
  }

  if (endpointUrl.protocol !== 'https:' || endpointUrl.pathname !== '/visit') {
    return;
  }

  fetch(endpointUrl.href, {
    method: 'POST',
    mode: 'cors',
    credentials: 'omit',
    cache: 'no-store',
    keepalive: true,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ path: window.location.pathname })
  }).catch(function () {
    // Visitor logging must not interrupt normal page use.
  });
})();
