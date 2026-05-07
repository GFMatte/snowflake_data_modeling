-- Source System Sample Data OLTP
select * from DEMO_TPCH.CH14_FACTS.SOURCE_SYSTEM_LINEITEM;



-- Landing EDW
select * from DEMO_TPCH.CH14_FACTS.SRC_LINEITEM;


-- Reverse Balance Fact Table
select * from DEMO_TPCH.CH14_FACTS.lineitem_rb;




select 
    srcl.*,
    max_asat
from src_lineitem srcl
left join(
    select 
        sales_order_id,
        max(asat_dts) as max_asat
    from lineitem_rb
    group by sales_order_id
    ) latest_asat
on srcl.sales_order_id = latest_asat.sales_order_id
where __ldts = (SELECT MAX(__ldts) FROM src_lineitem) 




    -- get ALL new/unprocessed records, but deduplicate to latest per key
    SELECT *
    FROM (
        SELECT 
              srcl.*
            , latest_asat.max_asat
            , ROW_NUMBER() OVER (
                PARTITION BY srcl.line_number, srcl.sales_order_id
                ORDER BY srcl.__ldts DESC
              ) AS rn
        FROM src_lineitem srcl
        LEFT JOIN (
            SELECT 
                sales_order_id, 
                MAX(asat_dts) AS max_asat
            FROM lineitem_rb
            GROUP BY sales_order_id
        ) latest_asat
        ON srcl.sales_order_id = latest_asat.sales_order_id

        -- 👇 process ALL new data, not just MAX
        WHERE srcl.__ldts > COALESCE(
            (SELECT MAX(asat_dts) FROM lineitem_rb), 
            '1900-01-01'::timestamp_ntz
        )
    )
    WHERE rn = 1   -- 👈 keep only latest version per key









select * from DEMO_TPCH.CH14_FACTS.STRM_LINEITEM_RB
where line_number = 20047139;


-- Reverse Balance Fact Table
select * from DEMO_TPCH.CH14_FACTS.lineitem_rb
where line_number = 20047139;



select * from line_load_hist;