"""Scheduled collector scaffold. Providers are deliberately disabled until
their public API terms, schema, units and timestamps have been verified."""
import os, json, datetime
def main():
    configured = [k for k in ("XAUUSD_API_URL","USDINR_API_URL","IBJA_API_URL") if os.getenv(k)]
    print(json.dumps({
        "run_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "configured_sources": configured,
        "status": "CONFIGURATION_ONLY" if not configured else "ADAPTERS_REQUIRE_VALIDATION",
        "note": "No price is invented. Implement and test each provider adapter before publishing forecasts."
    }))
if __name__ == "__main__": main()
