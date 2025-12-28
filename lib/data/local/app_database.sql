CREATE TABLE profiles (
  uid TEXT PRIMARY KEY,
  email TEXT,
  name TEXT,
  age INTEGER,
  totalWorkouts INTEGER,
  totalDistance REAL,
  lastModified INTEGER
);

CREATE TABLE workouts (
  id TEXT PRIMARY KEY,
  uid TEXT,
  date INTEGER,
  type TEXT,
  duration INTEGER,
  calories INTEGER,
  lastModified INTEGER,
  synced INTEGER DEFAULT 0
);
