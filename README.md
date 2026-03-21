# CSDS 397 – Assignment 3

## Requirements

- Python 3.8+
- PostgreSQL 16

## Setup

Run the setup script once to install Python dependencies, configure PostgreSQL, and create the database:

```bash
bash setup.sh
```

## Run

```bash
python3 analysis.py
```

Results are written to the `gold` schema in the `employee_analytics` PostgreSQL database.

## Repository Structure

```
csds397-assignment3/
├── README.md                          # Setup and run instructions
├── report.md                          # Full analysis report
├── analysis.py                        # Transformation script (pandas + SQLAlchemy)
├── setup.sh                           # One-time environment setup
├── employee_data_clean.csv            # Source data (700 rows)
└── sql/
    ├── 01_salary_to_department_analysis.sql
    ├── 02_salary_to_tenure_analysis.sql
    ├── 03_performance_by_salary_analysis.sql
    ├── 04_salary_by_country_analysis.sql
    ├── 05_department_performance_analysis.sql
    ├── 06_sales_productivity_analysis.sql
    └── 07_age_band_salary_analysis.sql
```
