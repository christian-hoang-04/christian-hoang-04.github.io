# Visitor IP logging setup

Visitor logging is deployed with a Cloudflare Worker and D1 database. The browser sends only the page path to the Worker. Cloudflare supplies the request IP in `CF-Connecting-IP`; the Worker stores that IP, the page path, and a UTC timestamp. A daily scheduled task removes records older than 30 days (deletion can happen up to 24 hours after a record passes that age). The Worker has no public endpoint for reading stored logs.

This logs browser page views when JavaScript runs. It is not a full GitHub Pages access log and may miss bots or visitors with JavaScript disabled.

The current Worker URL is `https://christian-hoang-visitor-log.ip-logger.workers.dev/visit`. It is configured in `src/visitor-tracker-config.js` and becomes active when the updated static site is published.

The Worker URL is public so browsers can submit visits. The exact-origin check limits normal browser use to this site, but it does not authenticate non-browser scripts. The Worker records the real source IP of each accepted request; monitor Cloudflare request and D1 usage, and disable the Worker if you see unexpected traffic.

## Current Cloudflare resources

- Worker: `christian-hoang-visitor-log`
- Worker URL: `https://christian-hoang-visitor-log.ip-logger.workers.dev`
- D1 database: `christian-hoang-visits` (APAC region)
- D1 database ID: `be5233f2-321f-404e-b3ef-25a690027ac8`
- Scheduled cleanup: daily at 03:00 UTC

## Redeploy or maintain the logger

1. Use the Cloudflare account that owns the resources above. The free Workers plan has usage limits; see the official [Workers pricing](https://developers.cloudflare.com/workers/platform/pricing/) and [D1 pricing and limits](https://developers.cloudflare.com/d1/platform/pricing/).
2. Install Node.js if it is not already available, then open PowerShell in this project's `ip-logger` folder.
3. Authenticate Wrangler in your browser if needed:

   ```powershell
   npx wrangler@latest login
   ```

4. Apply any pending schema changes and deploy the Worker:

   ```powershell
   npx wrangler@latest d1 migrations apply christian-hoang-visits --remote
   npx wrangler@latest deploy
   ```

   Wrangler prints the deployed Worker URL. The browser endpoint is that URL with `/visit` appended.

## Activate website tracking

The current value in `src/visitor-tracker-config.js` is:

```js
window.VISITOR_LOG_ENDPOINT = 'https://christian-hoang-visitor-log.ip-logger.workers.dev/visit';
```

The website update must be published through the project's normal GitHub Pages workflow for browser visits to be recorded.

## View or delete records

From the `ip-logger` folder, use authenticated Wrangler to view the newest 100 records:

```powershell
npx wrangler@latest d1 execute christian-hoang-visits --remote --command "SELECT ip_address, visited_at, path FROM visits ORDER BY visited_at DESC LIMIT 100;"
```

To delete all records manually:

```powershell
npx wrangler@latest d1 execute christian-hoang-visits --remote --command "DELETE FROM visits;"
```

The Worker stores only IP address, page path, and visit time. It does not store query parameters, fragments, referrers, user-agent strings, or cookies. The website's [visitor logging notice](privacy.html) documents collection and the 30-day retention period.
