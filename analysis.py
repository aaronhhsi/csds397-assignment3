"""
Assignment 3 - Employee Data Analysis
Loads employee_data_clean.csv into PostgreSQL as raw_employees,
then executes each SQL script in sql/ to populate the gold schema.
"""

import glob
import pandas as pd
from sqlalchemy import create_engine, text

DB_URL = "postgresql+psycopg2://analyst:analyst123@localhost:5432/employee_analytics"
engine = create_engine(DB_URL)

# ── Load raw data into PostgreSQL ────────────────────────────────────────────
df = pd.read_csv("employee_data_clean.csv")
print(f"Loaded {len(df)} rows\n")

df.columns = [c.lower().replace(" ", "_") for c in df.columns]
df.to_sql("raw_employees", engine, schema="public", if_exists="replace", index=False)
print("Staged raw_employees table\n")

# ── Execute each SQL script in order ─────────────────────────────────────────
sql_files = sorted(glob.glob("sql/*.sql"))

with engine.connect() as conn:
    for path in sql_files:
        with open(path) as f:
            sql = f.read()
        conn.execute(text(sql))
        conn.commit()

        table_name = path.split("/")[-1].replace(".sql", "").split("_", 1)[1]
        result = pd.read_sql(f"SELECT * FROM gold.{table_name}", conn)
        print(f"=== {table_name} ===")
        print(result.to_string(index=False))
        print()

# ── Summary ───────────────────────────────────────────────────────────────────
with engine.connect() as conn:
    tables = pd.read_sql(
        "SELECT table_name FROM information_schema.tables "
        "WHERE table_schema = 'gold' ORDER BY table_name",
        conn,
    )
print("=== Gold Schema Tables ===")
print(tables.to_string(index=False))
print("\nDone.")
