DECLARE @string nvarchar(max);
DECLARE @num int;

/* 
We have a string(@string) that is concatenated result of several key splited by '_'.
We need a script to find a date from key.
Date is always X part in a key(@num)
*/ 
SET @string = '109_1_330_06012022_53_13:08:332';
SET @num = 4;

-- Solution #1
SELECT date_part
FROM (
	SELECT
		value as date_part
		, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS row_id
	FROM STRING_SPLIT (@string , '_' )
) src 
WHERE row_id = @num


-- Solution #2
SELECT JSON_VALUE('["'+REPLACE(@string,'_','","')+'"]', CONCAT('$[',@num-1,']'));