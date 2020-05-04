-- Load data to Table
create table monthly_sales (
	product varchar(10),
	month date,
	sales_revenue decimal(10,2)
);

COPY monthly_sales (product, month, sales_revenue)
FROM '/Users/hkim/Public/monthly_sales.csv' 
DELIMITER ',' CSV HEADER;

