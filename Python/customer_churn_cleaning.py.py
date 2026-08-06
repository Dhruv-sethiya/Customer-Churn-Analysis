import pandas as pd
from sqlalchemy import create_engine, text

# ======================================
# Customer Churn Analytics ETL Project
# ======================================

# File Path
file_path = "../data/customer_churn_cleaned.csv"
print("Reading CSV...")

df = pd.read_csv(file_path)
df.rename(columns={
    "customerid": "customer_id"
}, inplace=True)

print(df.columns.tolist())
print(f"Rows: {len(df):,}")
print(df.head())

# Connect MySQL
engine = create_engine(
    "mysql+pymysql://root:1234@localhost/customer_churn"
)

# Clear Old Data
with engine.begin() as conn:
    conn.execute(text("TRUNCATE TABLE staging_customer_churn"))

print("Loading data...")

df.to_sql(
    name="staging_customer_churn",
    con=engine,
    if_exists="append",
    index=False
)

print("Data Imported Successfully!")

# Verify Import
with engine.connect() as conn:
    result = conn.execute(
        text("SELECT COUNT(*) FROM staging_customer_churn")
    )

    print(f"Rows in MySQL: {result.scalar():,}")

print("ETL Completed Successfully!")
