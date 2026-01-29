create database task9_star_schema;
use task9_star_schema;

create table task9_star_schema.retail_sales9 LIKE task8_window.retail_sales;
insert into task9_star_schema.retail_sales9 select * from task8_window.retail_sales;


-- Star Schema:  Looks like a * (star), that’s why the name.
				-- 1.  main table → numbers (sales, quantity)
				-- 2.  Small side tables → details (customer, product, date, country)
                
-- Decide which table is what
					-- Rule (easy):
							-- Numbers → Fact table
							-- Names / dates → Dimension tables
                            
-- ###----------Ceate Dimension Tables (Small tables)----------------###

-- 1. Customer Dimension 
create table dim_customer(
	 customer_key int auto_increment primary key,          -- customer_key = internal ID (MySQL creates it)
     customer_id int                                       -- customer_id = original value from dataset
 );

-- 2. Product Dimension
create table dim_product(
	 product_key int auto_increment primary key,
     stock_code varchar(50)
);

-- 3. country Dimension
create table dim_country(
	 country_key int auto_increment primary key,
     country varchar(100)
);

-- 4. Date Dimension
create table dim_date(
	date_key int auto_increment primary key,
    invoice_date date,
    year int,
    month int,
    day int
);


-- ###----------Ceate Fact Table (Main table)----------------###
                   --  Fact table does not store names
				   --  It stores keys (IDs) from dimension tables
create table fact_sales(
		sales_key int auto_increment primary key,
        customer_key int,
        product_key int,
        country_key int,
        date_key int,
        quantity int,
        unit_price decimal(10,2),
        sales decimal(10,2)
);


-- ###----------Fill Dimension Tables (Small tables)----------------###

insert into dim_customer(customer_id)
select distinct CustomerID
from retail_sales9
where CustomerID is not null;	

insert into dim_product(stock_code)
select distinct StockCode
from retail_sales9;

insert into dim_country(country)
select distinct Country
from retail_sales9;

insert into dim_date(invoice_date, year, month, day)
select distinct
	  date(InvoiceDate),
	  year(InvoiceDate),
	  month(InvoiceDate),
	  day(InvoiceDate)
from retail_sales9;

create table fact_sales(
		sales_key int auto_increment primary key,
        customer_key int,
        product_key int,
        country_key int,
        date_key int,
        quantity int,
        unit_price decimal(10,2),
        sales decimal(10,2)
);
-- ###----------Insert data into Fact Table (Main table)----------------###
select dc.customer_key,
       dp.product_key,
       dco.country_key,
       dd.date_key,
       o.Quantity,
       o.UnitPrice,
       o.Quantity*o.UnitPrice
from retail_sales9 o
join dim_customer dc on o.CustomerID= dc.customer_id
join dim_product dp on o.StockCode= dp.stock_code
join dim_country dco on o.Country= dco.country
join dim_date dd on DATE(o.InvoiceDate)= dd.invoice_date;


-- ###---------- Create Indexes ----------------###
create index idx_fact_customer on fact_sales(customer_key);
create index idx_fact_product on fact_sales(product_key);
create index idx_fact_date on fact_sales(date_key);


-- ###---------- Business Analytics Queries ----------------###

-- 1. TOTAL SALES BY COUNTRY
select co.country, sum(f.sales) total_sales
from fact_sales f join
         dim_country co on f.country_key= co.country_key
group by co.country
order by total_sales desc;

-- 2. MONTHLY SALES TREND
select d.year, d.month, sum(f.sales) total_sales
from fact_sales f join
           dim_date d on f.date_key= d.date_key
group by d.year, d.month
order by d.year, d.month;

-- 3. TOP 10 PRODUCTS BY REVENUE
select p.stock_code, sum(f.sales) total_sales
from fact_sales f join 
           dim_product p on f.product_key= p.product_key
group by p.product_key
order by total_sales desc
limit 10;
