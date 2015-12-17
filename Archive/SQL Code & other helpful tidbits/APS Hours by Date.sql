declare @beginDate date
declare @endDate date
declare @employee varchar
declare @bTemp int

set @beginDate = '5/27/2012'
set @endDate = '5/31/2012'
set @employee = '%'
set @bTemp = 1
select a.Emp_ID
, a.Emp_Name
, a.Period_End_Date
, a.Date_Entered
, a.DateTimeApproved
, sum(a.Day1Hours) as Mon
, sum(a.Day2Hours) as Tue
, sum(a.Day3Hours) as Wed
, sum(a.Day4Hours) as Thr
, sum(a.Day5Hours) as Fri
, sum(a.Day6Hours) as Sat
, sum(a.Day7Hours) as Sun
, SUM(a.reg_hours) as 'Hrs'
, SUM(a.PTOHours) as 'PTOHrs'
, SUM(a.UnPaidHours) as 'UnPaidHrs'
from
(SELECT 
    CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7 
	THEN PJTIMDET.tl_date + 1
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 6
	THEN PJTIMDET.tl_date + 2
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 5 
	THEN PJTIMDET.tl_date + 3
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 4 
	THEN PJTIMDET.tl_date + 4
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 3 
	THEN PJTIMDET.tl_date + 5
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 2 
	THEN PJTIMDET.tl_date + 6
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 1 
	THEN PJTIMDET.tl_date END as 'Period_End_Date'
	, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 2
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day1Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 3
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day2Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 4
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day3Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 5
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day4Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 6
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day5Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day6Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day7Hours'
, PJTIMDET.tl_date as 'Date_Entered'
, PJTIMDET.reg_hours
, ISNULL((select PJTIMDET.reg_hours where PJPROJ.pm_id02 = '1TIGUP' AND PJTIMDET.project = 'UPT'),0) as 'UnPaidHours' -- Dan added 01/04/2012 DAB
, REPLACE(PJEMPLOY.emp_name,'~',', ') as 'Emp_Name'
, PJEMPLOY.employee as 'Emp_ID'
, ISNULL((select PJTIMDET.reg_hours
	where PJPROJ.pm_id01 = '1TIGPT' AND PJPROJ.pm_id02 = 'PTO' OR PJTIMDET.project IN ('03070209AGY','03070309AGY')),0) as 'PTOHours'
, PJEMPLOY.user2 as 'ADPFileID'
, ISNULL((select a.Temporary_Employee 
	from 
	(Select * from OpenQuery([xRHSQL.Bridge], 'Select UserName, Temporary_Employee from Bridge.Associate where Temporary_Employee = 1'))a 
		where a.UserName = PJEMPLOY.employee),0) as 'TempEmp'
, PJTIMDET.tl_id19 as 'DateTimeCompleted'  -- DAB added 4/23/2012 
, PJTIMDET.tl_id09 as 'DateTimeApproved'  -- DAB added 4/23/2012
FROM PJEMPLOY JOIN xPJEMPPJT_Wages ON PJEMPLOY.employee = xPJEMPPJT_Wages.employee 
	JOIN PJTIMDET ON xPJEMPPJT_Wages.employee = PJTIMDET.employee 
	LEFT JOIN PJPROJ ON PJTIMDET.project = PJPROJ.project 
WHERE xPJEMPPJT_Wages.ep_id05 in ('S2', 'HR', 'S1')
and PJTIMDET.tl_date > '12/31/2010'
--and PJTIMDET.tl_date between @beginDate and @endDate
)a
where a.DateTimeApproved between @beginDate and @endDate
and a.Date_Entered <= a.DateTimeApproved
group by a.Emp_ID, a.Emp_Name, a.Period_End_Date, a.Date_Entered, a.DateTimeApproved