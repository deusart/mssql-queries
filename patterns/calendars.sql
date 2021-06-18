DECLARE @StartDate  date = '20100101';

DECLARE @CutoffDate date = getdate();

;WITH sequance(number) AS 
(
  SELECT 0 UNION ALL SELECT number + 1 FROM sequance
  WHERE number < DATEDIFF(DAY, '20190101', getdate())
),
dates(date_time) AS 
(
  SELECT DATEADD(DAY, number, '20190101') FROM sequance
),
calendar AS
(
  SELECT
    calendar_date			= CONVERT(date, date_time)
	, calendar_day			= DATEPART(DAY, date_time)
	, calendar_day_name		= DATENAME(WEEKDAY, date_time)
	, calendar_week			= DATEPART(WEEK, date_time)
	, calendar_iso_week		= DATEPART(ISO_WEEK, date_time)
	, calendar_week_day		= DATEPART(WEEKDAY, date_time)
	, calendar_month		= DATEPART(MONTH, date_time)
	, calendar_month_name	= DATENAME(MONTH, date_time)
	, calendar_quarter		= DATEPART(Quarter, date_time)
	, calendar_year			= DATEPART(YEAR, date_time)
	, calendar_month_start	= DATEFROMPARTS(YEAR(date_time), MONTH(date_time), 1)
	, calendar_year_day		= DATEPART(DAYOFYEAR, date_time)	
  FROM dates
)
SELECT -- * 
stdevp(calendar_day)
FROM calendar
OPTION (MAXRECURSION 0);