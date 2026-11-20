CREATE TABLE IF NOT EXISTS market_observations (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 instrument TEXT NOT NULL,
 interval TEXT NOT NULL,
 ts_utc TEXT NOT NULL,
 open REAL, high REAL, low REAL, close REAL NOT NULL,
 volume REAL,
 source TEXT NOT NULL,
 source_timestamp TEXT,
 quality_status TEXT NOT NULL DEFAULT 'unverified',
 UNIQUE(instrument, interval, ts_utc, source)
);
CREATE INDEX IF NOT EXISTS idx_obs_lookup ON market_observations(instrument, interval, ts_utc);
CREATE TABLE IF NOT EXISTS benchmark_rates (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 benchmark TEXT NOT NULL,
 purity TEXT NOT NULL,
 rate_inr_per_gram REAL NOT NULL,
 observed_at_utc TEXT NOT NULL,
 observed_session TEXT,
 source TEXT NOT NULL,
 quality_status TEXT NOT NULL DEFAULT 'unverified',
 UNIQUE(benchmark, purity, observed_at_utc, source)
);
CREATE TABLE IF NOT EXISTS macro_observations (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 series_id TEXT NOT NULL,
 observed_date TEXT NOT NULL,
 value REAL NOT NULL,
 source TEXT NOT NULL,
 UNIQUE(series_id, observed_date, source)
);
CREATE TABLE IF NOT EXISTS forecasts (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 model_version TEXT NOT NULL,
 instrument TEXT NOT NULL,
 horizon TEXT NOT NULL,
 created_at_utc TEXT NOT NULL,
 input_cutoff_utc TEXT NOT NULL,
 expected_price REAL,
 lower_price REAL,
 upper_price REAL,
 p_up REAL,
 p_down REAL,
 p_sideways REAL,
 confidence_label TEXT,
 direction TEXT,
 feature_snapshot_json TEXT NOT NULL,
 UNIQUE(model_version, instrument, horizon, created_at_utc)
);
CREATE TABLE IF NOT EXISTS forecast_outcomes (
 forecast_id INTEGER PRIMARY KEY,
 resolved_at_utc TEXT NOT NULL,
 actual_price REAL,
 absolute_error REAL,
 percentage_error REAL,
 direction_correct INTEGER,
 range_covered INTEGER,
 FOREIGN KEY(forecast_id) REFERENCES forecasts(id)
);
CREATE TABLE IF NOT EXISTS source_health (
 source TEXT PRIMARY KEY,
 last_success_utc TEXT,
 last_attempt_utc TEXT,
 status TEXT NOT NULL,
 message TEXT
);
