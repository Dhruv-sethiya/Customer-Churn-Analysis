import getpass
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text


# ======================================
# Customer Churn Analytics ETL Project
# ======================================

# Project root
BASE_DIR = Path(__file__).resolve().parents[1]

# CSV file
file_path = BASE_DIR / "Data" / "customer_churn_cleaned.csv"

print("Reading CSV...")
print(f"File: {file_path}")

df = pd.read_csv(file_path)

# Standardize customer ID column
df.rename(columns={
    "customerid": "customer_id"
}, inplace=True)

print(f"Rows in CSV: {len(df):,}")
print(f"Columns: {len(df.columns)}")

# MySQL credentials
mysql_password = getpass.getpass("Enter MySQL root password: ")

engine = create_engine(
    f"mysql+pymysql://root:{mysql_password}@localhost/customer_churn"
)

# Clear existing staging data
print("Clearing existing staging data...")

with engine.begin() as conn:
    conn.execute(text("TRUNCATE TABLE staging_customer_churn"))

# Load data
print("Loading data into MySQL...")

df.to_sql(
    name="staging_customer_churn",
    con=engine,
    if_exists="append",
    index=False
)

print("Data imported successfully!")

# Verify import
with engine.connect() as conn:
    result = conn.execute(
        text("SELECT COUNT(*) FROM staging_customer_churn")
    )
    rows_in_mysql = result.scalar()

print(f"Rows in MySQL: {rows_in_mysql:,}")

if rows_in_mysql == len(df):
    print("ETL validation successful!")
else:
    print("WARNING: CSV and MySQL row counts do not match.")

print("ETL completed successfully!")
