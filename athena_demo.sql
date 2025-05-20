--Please select tpch_iceberg database in the drop down menu on the left, before starting queries (if not already selected)


--450,000,000
SELECT count(*) FROM "tpch_iceberg"."customer";

--Preview data
SELECT * FROM "tpch_iceberg"."customer" limit 10;

--Select data for market segment, 90,004,641
select count(*) from "tpch_iceberg"."customer" where c_mktsegment = 'BUILDING';

--Deletion
delete from "tpch_iceberg"."customer" where c_mktsegment = 'BUILDING';

--Confirm deletion
select count(*) from "tpch_iceberg"."customer" where c_mktsegment = 'BUILDING';

--Select data for nation key
select * from "tpch_iceberg"."customer" where c_nationkey = 21 limit 10;

--Update the phone numbers
update "tpch_iceberg"."customer"
set c_phone = '+972-' || c_phone
where c_nationkey = 21;

--Confirm update
select * from "tpch_iceberg"."customer" where c_nationkey = 21 limit 10;

--Query previous state, 10 mins back
select count(*) 
from "tpch_iceberg"."customer" for timestamp as of current_timestamp - INTERVAL '10' MINUTE
where c_mktsegment = 'BUILDING';

--History
select * from tpch_iceberg."customer$history";

--Snapshots
select * from tpch_iceberg."customer$snapshots";

--Files
select * from tpch_iceberg."customer$files";



--Staging table
select * from "tpch_iceberg"."customer" where c_custkey = 259360431000;

--Merge statement
MERGE INTO customer AS target
USING (SELECT * FROM customer_stg) AS source
ON (target.c_custkey = source.c_custkey)
WHEN MATCHED THEN
    UPDATE SET
        c_name = source.c_name,c_address = source.c_address,c_nationkey = source.c_nationkey,c_phone = source.c_phone,
        c_acctbal = source.c_acctbal,c_mktsegment = source.c_mktsegment,c_comment = source.c_comment
WHEN NOT MATCHED THEN
    INSERT VALUES (source.c_custkey,source.c_name,source.c_address,
        source.c_nationkey,source.c_phone,source.c_acctbal,source.c_mktsegment,source.c_comment);

--Confirm merge insert       
select * from "tpch_iceberg"."customer" where c_custkey = 259360431000;