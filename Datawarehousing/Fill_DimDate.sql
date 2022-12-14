use northwinddwh;

drop procedure if exists sp_day_dim;

truncate table DimDate;

delimiter //

CREATE PROCEDURE sp_DimDate ()
BEGIN

  Declare StartDate datetime;
  Declare EndDate datetime;
  Declare RunDate datetime;

-- Set date variables

  Set StartDate = '2020-01-01'; -- update this value to reflect the earliest date that you will use.
  Set EndDate = '2023-01-01'; -- update this value to reflect the latest date that you will use.
  Set RunDate = StartDate;

-- Loop through each date and insert into DimTime table

WHILE RunDate <= EndDate DO

INSERT Into DimDate(
 date ,
 dateKey,
 day_num ,
 Day_of_Year,
 Day_of_Week,
 Day_of_week_name,
 Week_num,
 week_begin_date,
 week_end_date,
 last_week_begin_date,
 last_week_end_date,
 last_2_week_begin_date,
 last_2_week_end_date,
 Month_num ,
 Month_Name,
 yearmonth_num,
 last_month_num,
 last_month_name,
 last_month_year,
 last_yearmonth_num,
 Quarter_num ,
 Year_num  ,
 created_date, 
 updated_date 
)
select 
RunDate date
,CONCAT(year(RunDate), lpad(MONTH(RunDate),2,'0'),lpad(day(RunDate),2,'0')) date_num
,day(RunDate) day_num
,DAYOFYEAR(RunDate) day_of_year
,DAYOFWEEK(RunDate) day_of_week
,DAYNAME(RunDate) day_of_week_name
,WEEK(RunDate) week_num
,DATE_ADD(RunDate, INTERVAL(1-DAYOFWEEK(RunDate)) DAY) week_begin_date
,ADDTIME(DATE_ADD(RunDate, INTERVAL(7-DAYOFWEEK(RunDate)) DAY),'23:59:59') week_end_date
,DATE_ADD(RunDate, INTERVAL ((1-DAYOFWEEK(RunDate))-7) DAY) last_week_begin_date
,ADDTIME(DATE_ADD(RunDate, INTERVAL ((7-DAYOFWEEK(RunDate))-7) DAY),'23:59:59')last_week_end_date
,DATE_ADD(RunDate, INTERVAL ((1-DAYOFWEEK(RunDate))-14) DAY) last_2_week_begin_date
,ADDTIME(DATE_ADD(RunDate, INTERVAL ((7-DAYOFWEEK(RunDate))-7) DAY),'23:59:59')last_2_week_end_date
,MONTH(RunDate) month_num
,MONTHNAME(RunDate) month_name
,CONCAT(year(RunDate), lpad(MONTH(RunDate),2,'0')) YEARMONTH_NUM
,MONTH(date_add(RunDate,interval -1 month)) last_month_num
,MONTHNAME(date_add(RunDate,interval -1 month)) last_month_name
,year(date_add(RunDate,interval -1 month)) last_month_year
,CONCAT(year(date_add(RunDate,interval -1 month)),lpad(MONTH(date_add(RunDate,interval -1 month)),2,'0')) Last_YEARMONTH_NUM
,QUARTER(RunDate) quarter_num
,YEAR(RunDate) year_num
,now() created_date
,now() update_date
;
-- commit;
-- increase the value of the @date variable by 1 day

Set RunDate = ADDDATE(RunDate,1);

END WHILE;
commit;
END;



CALL sp_DimDate ()