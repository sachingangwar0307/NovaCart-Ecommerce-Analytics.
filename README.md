# NovaCart E-commerce Analytics

An end-to-end e-commerce analytics project using **MySQL, Python (Pandas), Excel, and exported CSV reports**. The project examines sales, profitability, customer purchasing behaviour, product performance, regional performance, and order operations.

## Project overview

NovaCart is an e-commerce dataset containing customer, product, order, and order-item records. The analysis uses delivered orders for sales and profit KPIs, while operational analysis also examines returned and cancelled orders.

## Tools used

- **MySQL** — database creation, data loading, validation, business analysis, and business-question queries
- **Python** — Pandas-based analysis in Jupyter Notebook
- **Excel** — source workbook containing customer, product, order, and order-item sheets
- **CSV** — exported KPI and analysis outputs

## Repository structure

```text
NovaCart-Ecommerce-Analytics/
├── data/
│   └── NovaCart_Data.xlsx
├── notebooks/
│   └── NovaCart_Analysis.ipynb
├── reports/
│   ├── NovaCart_KPIs.csv
│   ├── NovaCart_monthly_growth.csv
│   ├── NovaCart_product_performance.csv
│   └── NovaCart_yearly.csv
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_business_analysis.sql
│   ├── 03_operations_analysis.sql
│   ├── 04_business_questions.sql
│   └── 05_data_validation.sql
└── README.md
```

## Key metrics

The current KPI export contains the following results. Values are reproduced from `reports/NovaCart_KPIs.csv`.

| KPI | Value |
|---|---:|
| Total revenue | ₹560,798,797.11 |
| Total profit | ₹214,520,693.54 |
| Profit margin | 38.25% |
| Total orders | 50,000 |
| Total customers | 10,000 |
| Average order value | ₹11,215.98 |
| Return rate | 6.01% |
| Cancellation rate | 8.28% |
| Repeat customer rate | 19.24% |

> Note: These are the values in the current exported KPI file. Re-run the notebook and SQL queries if the source data or KPI definitions change.

## Analysis areas

1. Overall revenue, profit, average order value, and profit margin
2. Yearly and monthly performance trends
3. Customer revenue contribution and repeat purchasing
4. Product revenue, profit, and loss-making products
5. Regional revenue and profitability
6. Order status, delivery performance, returns, and cancellations
7. SQL data-quality checks, including duplicate keys, unmatched relationships, and financial calculations

## How to run

### Python notebook

1. Clone or download this repository.
2. Install the required packages: `pandas`, `openpyxl`, `numpy`, and `matplotlib` (install `seaborn` too if running cells that use it).
3. Open `notebooks/NovaCart_Analysis.ipynb` in Jupyter Notebook or VS Code.
4. Run the cells from top to bottom. The notebook reads `../data/NovaCart_Data.xlsx` relative to the notebook folder.

### MySQL scripts

1. Create a MySQL database and run `sql/01_database_setup.sql`.
2. Update the `LOAD DATA INFILE` file paths in that script to match the location of your CSV source files and your MySQL `secure_file_priv` configuration.
3. Run the remaining scripts in numerical order.

## Currency conversion

Some SQL outputs convert INR to USD using a fixed exchange-rate assumption of **₹83 per USD**. This is a project assumption, not a live exchange rate.

## Notes

- The AtliQ Hardware SQL scripts were intentionally excluded because they belong to a separate project.
- The repository includes the current analysis workbook and exported CSV outputs; a Power BI `.pbix` file or dashboard screenshots were not present among the supplied project files.
