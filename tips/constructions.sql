-- Base Table
DECLARE @table_size BIGINT;
SET @table_size = 100;

DROP TABLE IF EXISTS #source;
SELECT TOP (@table_size) 
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS row_id
	, CONCAT('line_', ABS(CHECKSUM(NEWID()) % 10)) AS row_name
	, ABS(CHECKSUM(NEWID()) % 10) AS row_value
	, ABS(CHECKSUM(NEWID()) % 3) AS row_h1
INTO #source
FROM master..spt_values t1
CROSS JOIN master..spt_values t2
;

DROP TABLE IF EXISTS #target;
SELECT TOP (@table_size) 
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS row_id
	, CONCAT('line_', ABS(CHECKSUM(NEWID()) % 10)) AS row_name
INTO #target
FROM master..spt_values t1
CROSS JOIN master..spt_values t2
;
select * from #target
-- CTE
; WITH cte AS (
	SELECT row_id, row_value AS child_level_num, row_h1 as level_num
	FROM #source
	WHERE row_h1 = 0  AND row_value > row_h1
)
select * from cte

-- Windows Functions
SELECT row_id, row_name, row_value, row_h1
	, ROW_NUMBER() OVER (ORDER BY row_name) as ROW_NUMBER_function
	, RANK() OVER (ORDER BY row_name) as RANK_function
	, DENSE_RANK() OVER (ORDER BY row_name) as DENSE_RANK_function
	, NTILE(5) OVER (ORDER BY row_name) as NTILE_function
	, LAG(row_name, 2) OVER (PARTITION BY row_h1 ORDER BY row_name) as LAG_function
	, LEAD(row_name) OVER (ORDER BY row_name) as LEAD_function	
FROM #source

-- Merge
MERGE #target AS trg
USING #source AS src
ON (src.row_id = trg.row_id)
WHEN MATCHED AND trg.row_id = 0
    THEN UPDATE SET trg.row_name = 'MATCHED';
--WHEN NOT MATCHED
--    THEN INSERT VALUES(src.row_id+100, row_value)
--OUTPUT $action, inserted.*, deleted.*;

-- PIVOT
SELECT row_name, [0],[1],[2]
FROM (
	SELECT row_name, row_value, row_h1
	FROM #source 
) src
PIVOT (
    SUM(row_value) FOR row_h1 IN ([0],[1],[2])
) AS pvt
ORDER BY row_name