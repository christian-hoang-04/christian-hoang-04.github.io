CREATE TABLE visits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ip_address TEXT NOT NULL,
  path TEXT NOT NULL CHECK (length(path) <= 512),
  visited_at TEXT NOT NULL
);

CREATE INDEX visits_by_timestamp ON visits (visited_at);
