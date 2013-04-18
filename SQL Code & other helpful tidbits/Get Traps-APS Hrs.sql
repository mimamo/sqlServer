declare @PerBegDate smalldatetime
declare @PerEndDate smalldatetime
declare @PeriodsBack int

set @PerEndDate = '4/29/2012'
set @PerBegDate = @PerEndDate - 7
set @PeriodsBack = 1 

SELECT a.*
FROM(
SELECT  'TRAPS' as 'Type'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7 
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
, PJTIMDET.tl_date as 'Date_Entered'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 2 --Monday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day1Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 3 --Tuesday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day2Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 4 --Wednesday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day3Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 5 --Thursday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day4Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 6 --Friday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day5Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7 --Saturday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day6Hours'
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1 --Sunday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as 'Day7Hours'
, 0 as 'UnPaidHours' -- IW added 12/15/2011 RJW
, PJPROJ.pm_id01 as 'Client_ID'
, PJPROJ.pm_id02 as 'Product_ID'
, PJTIMDET.project as 'Project_ID'
, PJEMPLOY.emp_name as 'Emp_Name'
, PJEMPLOY.emp_status as 'Emp_Status'
, PJTIMHDR.th_status as 'TC_Status'
, xPJEMPPJT.ep_id05 as 'Empmnt_Status'
, xPJEMPPJT.effect_date as 'Effective_Date'
, PJEMPLOY.employee as 'Emp_ID'
, 0 as 'PTOHours'
, 0 as 'GENHours'
, 0 as 'WTDHours'
, PJPROJ.Project_Desc as 'Project'
, PJTIMDET.linenbr as 'LineNbr'
, PJTIMDET.docnbr as 'DocNbr'
, PJEMPLOY.user2 as 'ADPFileID'
, c.[Name] as 'Client'
, x.descr as 'Product'
, 0 as 'TempEmp'
, ISNULL(xd.gl_subacct, PJEMPLOY.gl_subacct) as 'Dept_ID'
, ISNULL(s.descr, sa.descr) as 'Department'
, ISNULL(PJEMPLOY.em_id16, 'CO') as 'WorkStateID'
, ISNULL([State].descr, 'Colorado') as 'WorkState'
, @PerBegDate as 'PerBegDate'
, @PerEndDate as 'PerEndDate'
, @PeriodsBack as 'PeriodsBack'
, PJTIMDET.tl_id19 as 'DateTimeCompleted'  -- DAB added 4/23/2012 
, PJTIMDET.tl_id09 as 'DateTimeApproved'  -- DAB added 4/23/2012
FROM PJEMPLOY (nolock) JOIN xPJEMPPJT ON PJEMPLOY.employee = xPJEMPPJT.employee 
	JOIN PJTIMDET (nolock) ON xPJEMPPJT.employee = PJTIMDET.employee 
	JOIN PJTIMHDR (nolock) ON PJTIMDET.docnbr = PJTIMHDR.docnbr 
	LEFT JOIN PJPROJ (nolock) ON PJTIMDET.project = PJPROJ.project 
	LEFT JOIN Customer c (nolock) ON PJPROJ.pm_id01 = C.custID
	LEFT JOIN xIGProdCode x (nolock) on PJPROJ.pm_id02 = x.code_ID
	LEFT JOIN xvr_TM096_Dept xd ON PJTIMDET.docnbr = xd.bill_batch_id
	LEFT JOIN Subacct s (nolock) ON xd.gl_subacct = s.sub
	LEFT JOIN Subacct sa (nolock) ON PJEMPLOY.gl_subacct = sa.sub
	LEFT JOIN [State] (nolock) ON PJEMPLOY.em_id16 = [State].StateProvID) a
WHERE a.Period_End_Date between @PerBegDate and @PerEndDate
and a.Emp_ID = 'nfrench'