# Star-Schema-Design-MySQL-Task-9
The objective of this task is to design and implement a **Star Schema** for sales data using MySQL.  This improves analytical querying and supports business reporting.

#  Dataset & Tools Used:
- ## Dataset:  Online Retail Dataset
- ## Tools:
     - MySQL Workbench
     - dbdiagram.io (for schema visualization)
     - GitHub (version control)

 # Key Columns:
- InvoiceDate
- CustomerID
- Country
- StockCode
- Quantity
- UnitPrice
- Sales

# Schema Design:
  - The data was converted from a single transactional table into a **Star Schema** consisting of:

     ## Dimension Tables
- dim_customer : customer details
- dim_product : product information
- dim_country : country details
- dim_date : date attributes (year, month, day)

     ## Fact Table
- fact_sales : sales metrics such as quantity, unit price, and total sales

     ## A visual representation of the schema is available in:
- star_schema_diagram.png

# Implementation Steps
1. Created dimension and fact tables in MySQL
2. Inserted distinct values into dimension tables
3. Loaded transactional data into the fact table using joins
4. Verified relationships and data integrity
5. Executed analytical queries on the star schema

# Sample Business Queries
- Total sales by country
- Monthly sales trends
- Top products by revenue
- 
# Outcome:
- The Star Schema enables faster queries, better readability, and scalable analytics suitable for BI tools.


