# PR Gold Tracker — Cloud starter

## Included
- `public/index.html`: existing PR dashboard with cloud forecast API integration.
- `worker/index.js`: Cloudflare Worker API (`/api/status`, `/api/predictions`).
- `migrations/0001_init.sql`: D1 schema for market data, benchmark rates, macro series, forecasts, outcomes and source health.
- `collector/collect.py`: safe scheduled collector scaffold. It intentionally does not fabricate prices or assume undocumented provider schemas.
- `.github/workflows/collector.yml`: scheduled GitHub Actions job.

## Deploy outline
1. Create a Cloudflare D1 database named `pr-gold-tracker`.
2. Replace the database ID in `wrangler.toml`.
3. Run `npx wrangler d1 execute pr-gold-tracker --remote --file=migrations/0001_init.sql`.
4. Deploy the Worker with `npx wrangler deploy`.
5. Publish `public/` with Cloudflare Pages and route `/api/*` to the Worker (or configure a Pages Function proxy).
6. Push this repository to GitHub and enable Actions.
7. Add provider secrets only after selecting a source with documented public API access and validating its terms, response schema, units, timestamps, history depth and rate limits.

## Important current limitation
This is a cloud-ready integration scaffold, not a live deployed service. The Worker reads validated forecast rows from D1. The collector is intentionally configuration-only until real provider endpoints and schemas are verified. It does not generate fake predictions. No credentials are included.

## Model release gates
- Store UTC timestamps and source provenance.
- Reject stale, duplicated, malformed and out-of-order observations.
- Build 5m/15m/1h/4h/daily features only from available data.
- Use time-ordered walk-forward backtests; never random-shuffle time series.
- Compare against persistence and moving-average baselines.
- Calibrate probabilities and prediction intervals before displaying confidence as validated.
- Include transaction costs, spread and slippage in trading tests.
