USE [DALLASAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'PayrollGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[PayrollGet]
GO

CREATE PROCEDURE [dbo].[PayrollGet] 
	@sAgency varchar(max),
	@sPayGroup varchar(3),
	@sEmp_ID varchar(50),
	@sEmp_Pay_Type varchar(max),
	@begDate datetime,
	@endDate datetime
	
AS 

/*******************************************************************************************************
*   DALLASAPP.dbo.PayrollGet
*
*   Creator: David Martin
*   Date: 03/28/2016          
*   
*          
*   Notes: 


*
*
*   Usage:	set statistics io on

	execute DALLASAPP.dbo.PayrollGet @begDate = '03/01/2016',
		@endDate = '03/22/2016',
		@sAgency = NULL,
		@sPayGroup = NULL,
		@sEmp_ID = NULL,
		@sEmp_Pay_Type = 'S2'
		
		
	execute DALLASAPP.dbo.PayrollGet @begDate = '03/01/2016',
		@endDate = '03/22/2016',
		@sAgency = NULL,
		@sPayGroup = NULL,
		@sEmp_ID = NULL,
		@sEmp_Pay_Type = 'HR|S1|S2'
	
	

*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @begTime datetime
declare @endTime datetime
declare @begin datetime
declare @end datetime

---------------------------------------------
-- create temp tables
---------------------------------------------
declare @EmpPayType table 
(
	EmpPayType nvarchar(4000) primary key clustered
)

declare @Agency table 
(
	Agency nvarchar(4000) primary key clustered
)
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
set @begTime = '12:00:00 AM'
set @endTime = '11:59:59 PM'

-- These are not used in online report only SQL query
/*
declare @sAgency varchar(3)
declare @sPayGroup varchar(3)
declare @sEmp_ID varchar(50)
declare @sEmp_Pay_Type varchar(3)
declare @pEndDate datetime
declare @begDate datetime
declare @endDate datetime
set @begDate = '03/01/2016'
set @endDate = '03/22/2016'
set @pEndDate = '03/22/2016'
set @sAgency = NULL
set @sPayGroup = NULL
set @sEmp_ID = NULL
set @sEmp_Pay_Type = 'S2'
*/

if @sAgency is not null
begin

	insert @Agency (Agency)
	select Name
	from denverapp.dbo.SplitString(@sAgency)

end


if @sEmp_Pay_Type is not null
begin

	insert @EmpPayType (EmpPayType)
	select Name
	from denverapp.dbo.SplitString(@sEmp_Pay_Type)

end



SET @begin = Convert(datetime, Convert(char(10), @begDate, 103) + ' ' + Convert(char(8), @begTime, 108), 103)
SET @end = Convert(datetime, Convert(char(10), @endDate, 103) + ' ' + Convert(char(8), @endTime, 108), 103)

SELECT		tbl.Agency,
			Approver,
			Emp_ID,
			Emp_Name,
			Period_End_Date,
			Emp_Status,
			Emp_Pay_Type,
			Effective_Date,
			Dept_ID,
			Department,
			Project_ID,
			Project_Desc,
			Client_ID,
			Product_ID,
			WorkStateID,
			WorkState,
			PayGroup,
			ADPFileID,
			SUM(Mon) AS 'Mon',
			SUM(Tue) AS 'Tue',
			SUM(Wed) AS 'Wed',
			SUM(Thr) AS 'Thr',
			SUM(Fri) AS 'Fri',
			SUM(Sat) AS 'Sat',
			SUM(Sun) AS 'Sun',
			SUM(Mon+Tue+Wed+Thr+Fri+Sat+Sun) AS 'TotalHrs',
			CASE
				WHEN Project_ID IN('INTGEN10505AG','INTGEN10506AG','INTGEN10507AG','INTGEN10508AG','INTGEN10510AG','INTGEN10511AG','INTGEN10512AG','INTGEN10514AG','INTGEN10515AG','INTGEN10516AG','INTGEN10517AG','INTGEN10518AG','INTGEN10521AG') THEN SUM(Mon+Tue+Wed+Thr+Fri+Sat+Sun)
				ELSE 0
			END AS 'PTOHours',
			TC_Status,
			Last_Update AS 'DateTimeCompleted',
			Last_Update AS 'DateTimeApproved',
			0 AS 'TempEmp',
			Timecard_Type AS 'TimeCard_Type'
FROM		( /* Get Regular and Corrected Timesheet Data */
			SELECT		'AGY' AS Agency,
						COALESCE(LTRIM(RTRIM(E.emp_name)),'') AS 'Approver',
						C.pe_date AS 'Period_End_Date',
						'' AS 'Date_Entered', 
						D.day1_hr1 AS 'Mon',
						D.day2_hr1 AS 'Tue',
						D.day3_hr1 AS 'Wed',
						D.day4_hr1 AS 'Thr', 
						D.day5_hr1 AS 'Fri',
						D.day6_hr1 AS 'Sat',
						D.day7_hr1 AS 'Sun',
						LTRIM(RTRIM(F.customer)) AS 'Client_ID', 
						LTRIM(RTRIM(F.pm_id02)) AS 'Product_ID',
						LTRIM(RTRIM(d.project)) AS 'Project_ID',
						LTRIM(RTRIM(A.emp_name)) AS 'Emp_Name',
						LTRIM(RTRIM(A.emp_status)) AS 'Emp_Status', 
						LTRIM(RTRIM(C.le_status)) AS 'TC_Status',
						LTRIM(RTRIM(B.PayType)) AS 'Emp_Pay_Type',
						B.effect_date AS 'Effective_Date', 
						LTRIM(RTRIM(A.employee)) AS 'Emp_ID', 
						0 AS 'PTOHours', 
						LTRIM(RTRIM(F.project_desc)) AS 'Project_Desc',
						LTRIM(RTRIM(C.docnbr)) AS 'Docnbr', 
						CASE
							WHEN SUBSTRING(A.user2, 5, 27) = '' THEN 'MISSING'
							ELSE SUBSTRING(A.user2, 5, 27)
						END AS 'ADPFileID', 
						CASE
							WHEN LEFT(A.user2, 3) = '' THEN 'MISSING'
							ELSE LEFT(A.user2, 3)
						END AS 'PayGroup',
						LTRIM(RTRIM(G.Name)) AS 'Client',
						COALESCE(LTRIM(RTRIM(H.code_value_desc)),'') AS 'Product', 
						ISNULL(LTRIM(RTRIM(A.gl_subacct)),'') AS 'Dept_ID',
						COALESCE(LTRIM(RTRIM(I.Descr)),'') AS 'Department',
						ISNULL(NULLIF(COALESCE(LTRIM(RTRIM(A.em_id16)),'TX'), ''), 'TX')  AS 'WorkStateID',
						ISNULL(NULLIF(COALESCE(LTRIM(RTRIM(J.Descr)),'Texas'), ''), 'Texas') AS 'WorkState',
						C.lupd_datetime AS 'Last_Update',
						CASE
							WHEN C.le_type = 'R' THEN 'Original'
							ELSE 'Corrected'
						END AS 'Timecard_Type'
			FROM		DALLASAPP.dbo.PJEMPLOY A INNER JOIN
						DALLASAPP.dbo.PJLABHDR C ON A.employee = C.employee INNER JOIN
						(SELECT	subTable.docnbr,
								subTable.effect_date,
								X1.ep_id05 AS PayType
						FROM	DALLASAPP.dbo.PJEMPPJT AS X1 RIGHT OUTER JOIN
								(SELECT		X3.docnbr,
											X3.employee,
											MAX(X2.effect_date) AS 'effect_date'
								FROM		DALLASAPP.dbo.PJEMPPJT AS X2 RIGHT OUTER JOIN
											DALLASAPP.dbo.PJLABHDR AS X3 ON X2.employee = X3.employee AND X2.effect_date <= X3.pe_date
								GROUP BY	X3.docnbr, X3.employee) AS subTable ON  X1.employee = subTable.employee AND X1.effect_date = subTable.effect_date) B ON B.docnbr = C.docnbr LEFT OUTER JOIN
						DALLASAPP.dbo.PJLABDET D ON C.docnbr = D.docnbr LEFT OUTER JOIN
						DALLASAPP.dbo.PJEMPLOY E ON E.employee = C.Approver LEFT OUTER JOIN
						DALLASAPP.dbo.PJPROJ F ON D.project = F.project LEFT OUTER JOIN
						DALLASAPP.dbo.Customer G ON F.customer = G.CustId LEFT OUTER JOIN
						DALLASAPP.dbo.PJCODE H ON F.pm_id02 = H.code_value AND H.code_type = 'BCYC' LEFT OUTER JOIN
						DALLASAPP.dbo.SubAcct I ON A.gl_subacct = I.Sub LEFT OUTER JOIN
						DALLASAPP.dbo.State J ON A.em_id16 = J.StateProvId		
			WHERE		C.le_status IN ('P','X')
			
			UNION ALL
			
			/* Get Reversals For Corrections */
			
			SELECT		'AGY' AS Agency,
						COALESCE(LTRIM(RTRIM(E.emp_name)),'') AS 'Approver',
						C.pe_date AS 'Period_End_Date',
						'' AS 'Date_Entered', 
						D.day1_hr1 * -1 AS 'Mon',
						D.day2_hr1 * -1  AS 'Tue',
						D.day3_hr1 * -1  AS 'Wed',
						D.day4_hr1 * -1  AS 'Thr', 
						D.day5_hr1 * -1  AS 'Fri',
						D.day6_hr1 * -1  AS 'Sat',
						D.day7_hr1 * -1  AS 'Sun',
						LTRIM(RTRIM(F.customer)) AS 'Client_ID', 
						LTRIM(RTRIM(F.pm_id02)) AS 'Product_ID',
						LTRIM(RTRIM(d.project)) AS 'Project_ID',
						LTRIM(RTRIM(A.emp_name)) AS 'Emp_Name',
						LTRIM(RTRIM(A.emp_status)) AS 'Emp_Status', 
						LTRIM(RTRIM(CC.le_status)) AS 'TC_Status',
						LTRIM(RTRIM(B.PayType)) AS 'Emp_Pay_Type',
						B.effect_date AS 'Effective_Date', 
						LTRIM(RTRIM(A.employee)) AS 'Emp_ID', 
						0 AS 'PTOHours', 
						LTRIM(RTRIM(F.project_desc)) AS 'Project_Desc',
						LTRIM(RTRIM(CC.docnbr)) AS 'Docnbr', 
						CASE
							WHEN SUBSTRING(A.user2, 5, 27) = '' THEN 'MISSING'
							ELSE SUBSTRING(A.user2, 5, 27)
						END AS 'ADPFileID', 
						CASE
							WHEN LEFT(A.user2, 3) = '' THEN 'MISSING'
							ELSE LEFT(A.user2, 3)
						END AS 'PayGroup',
						LTRIM(RTRIM(G.Name)) AS 'Client',
						COALESCE(LTRIM(RTRIM(H.code_value_desc)),'') AS 'Product', 
						ISNULL(LTRIM(RTRIM(A.gl_subacct)),'') AS 'Dept_ID',
						COALESCE(LTRIM(RTRIM(I.Descr)),'') AS 'Department',
						ISNULL(NULLIF(COALESCE(LTRIM(RTRIM(A.em_id16)),'TX'), ''), 'TX')  AS 'WorkStateID',
						ISNULL(NULLIF(COALESCE(LTRIM(RTRIM(J.Descr)),'Texas'), ''), 'Texas') AS 'WorkState',
						CC.lupd_datetime AS 'Last_Update',
						'Corrected' AS 'Timecard_Type'
			FROM		DALLASAPP.dbo.PJEMPLOY A INNER JOIN
						DALLASAPP.dbo.PJLABHDR C ON A.employee = C.employee INNER JOIN
						(SELECT	subTable.docnbr,
								subTable.effect_date,
								X1.ep_id05 AS PayType
						FROM	DALLASAPP.dbo.PJEMPPJT AS X1 RIGHT OUTER JOIN
								(SELECT		X3.docnbr,
											X3.employee,
											MAX(X2.effect_date) AS 'effect_date'
								FROM		DALLASAPP.dbo.PJEMPPJT AS X2 RIGHT OUTER JOIN
											DALLASAPP.dbo.PJLABHDR AS X3 ON X2.employee = X3.employee AND X2.effect_date <= X3.pe_date
								GROUP BY	X3.docnbr, X3.employee) AS subTable ON  X1.employee = subTable.employee AND X1.effect_date = subTable.effect_date) B ON B.docnbr = C.docnbr LEFT OUTER JOIN
						DALLASAPP.dbo.PJLABHDR CC ON C.docnbr = CC.le_key INNER JOIN
						DALLASAPP.dbo.PJLABDET D ON C.docnbr = D.docnbr LEFT OUTER JOIN
						DALLASAPP.dbo.PJEMPLOY E ON E.employee = C.Approver LEFT OUTER JOIN
						DALLASAPP.dbo.PJPROJ F ON D.project = F.project LEFT OUTER JOIN
						DALLASAPP.dbo.Customer G ON F.customer = G.CustId LEFT OUTER JOIN
						DALLASAPP.dbo.PJCODE H ON F.pm_id02 = H.code_value AND H.code_type = 'BCYC' LEFT OUTER JOIN
						DALLASAPP.dbo.SubAcct I ON A.gl_subacct = I.Sub LEFT OUTER JOIN
						DALLASAPP.dbo.State J ON A.em_id16 = J.StateProvId	
			WHERE		C.le_status = 'X'
						AND CC.le_status IN ('P','X')
						AND CC.le_type = 'C'
			
			UNION ALL
						
			/* GET DALLAS STUDIO REGULAR TIME SHEETS */
			
			SELECT		'APS' AS Agency,
						COALESCE(LTRIM(RTRIM(E.emp_name)),'') AS 'Approver',
						C.pe_date AS 'Period_End_Date',
						'' AS 'Date_Entered', 
						D.day1_hr1 AS 'Mon',
						D.day2_hr1 AS 'Tue',
						D.day3_hr1 AS 'Wed',
						D.day4_hr1 AS 'Thr', 
						D.day5_hr1 AS 'Fri',
						D.day6_hr1 AS 'Sat',
						D.day7_hr1 AS 'Sun',
						LTRIM(RTRIM(F.customer)) AS 'Client_ID', 
						LTRIM(RTRIM(F.pm_id02)) AS 'Product_ID',
						LTRIM(RTRIM(d.project)) AS 'Project_ID',
						LTRIM(RTRIM(A.emp_name)) AS 'Emp_Name',
						LTRIM(RTRIM(A.emp_status)) AS 'Emp_Status', 
						LTRIM(RTRIM(C.le_status)) AS 'TC_Status',
						LTRIM(RTRIM(B.PayType)) AS 'Emp_Pay_Type',
						B.effect_date AS 'Effective_Date', 
						LTRIM(RTRIM(A.employee)) AS 'Emp_ID', 
						0 AS 'PTOHours', 
						LTRIM(RTRIM(F.project_desc)) AS 'Project_Desc',
						LTRIM(RTRIM(C.docnbr)) AS 'Docnbr', 
						CASE
							WHEN SUBSTRING(A.em_id02, 5, 27) = '' THEN 'MISSING'
							ELSE SUBSTRING(A.em_id02, 5, 27)
						END AS 'ADPFileID', 
						CASE
							WHEN LEFT(A.em_id02, 3) = '' THEN 'MISSING'
							ELSE LEFT(A.em_id02, 3)
						END AS 'PayGroup',
						LTRIM(RTRIM(G.Name)) AS 'Client',
						COALESCE(LTRIM(RTRIM(H.code_value_desc)),'') AS 'Product', 
						ISNULL(LTRIM(RTRIM(A.gl_subacct)),'') AS 'Dept_ID',
						COALESCE(LTRIM(RTRIM(I.Descr)),'') AS 'Department',
						ISNULL(NULLIF(COALESCE(LTRIM(RTRIM(A.em_id16)),'TX'), ''), 'TX')  AS 'WorkStateID',
						ISNULL(NULLIF(COALESCE(LTRIM(RTRIM(J.Descr)),'Texas'), ''), 'Texas') AS 'WorkState',
						C.lupd_datetime AS 'Last_Update',
						CASE
							WHEN C.le_type = 'R' THEN 'Original'
							ELSE 'Corrected'
						END AS 'Timecard_Type'
			FROM		DALLASSTUDIOAPP.dbo.PJEMPLOY A INNER JOIN
						DALLASSTUDIOAPP.dbo.PJLABHDR C ON A.employee = C.employee INNER JOIN
						(SELECT	subTable.docnbr,
								subTable.effect_date,
								X1.ep_id05 AS PayType
						FROM	DALLASSTUDIOAPP.dbo.PJEMPPJT AS X1 RIGHT OUTER JOIN
								(SELECT		X3.docnbr,
											X3.employee,
											MAX(X2.effect_date) AS 'effect_date'
								FROM		DALLASSTUDIOAPP.dbo.PJEMPPJT AS X2 RIGHT OUTER JOIN
											DALLASSTUDIOAPP.dbo.PJLABHDR AS X3 ON X2.employee = X3.employee AND X2.effect_date <= X3.pe_date
								GROUP BY	X3.docnbr, X3.employee) AS subTable ON  X1.employee = subTable.employee AND X1.effect_date = subTable.effect_date) B ON B.docnbr = C.docnbr LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.PJLABDET D ON C.docnbr = D.docnbr LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.PJEMPLOY E ON E.employee = C.Approver LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.PJPROJ F ON D.project = F.project LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.Customer G ON F.customer = G.CustId LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.PJCODE H ON F.pm_id02 = H.code_value AND H.code_type = 'BCYC' LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.SubAcct I ON A.gl_subacct = I.Sub LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.State J ON A.em_id16 = J.StateProvId		
			WHERE		C.le_status IN ('P','X')
			
			UNION ALL
			
			/* Get Reversals For Corrections Studio */
			
			SELECT		'APS' AS Agency,
						COALESCE(LTRIM(RTRIM(E.emp_name)),'') AS 'Approver',
						C.pe_date AS 'Period_End_Date',
						'' AS 'Date_Entered', 
						D.day1_hr1 * -1 AS 'Mon',
						D.day2_hr1 * -1  AS 'Tue',
						D.day3_hr1 * -1  AS 'Wed',
						D.day4_hr1 * -1  AS 'Thr', 
						D.day5_hr1 * -1  AS 'Fri',
						D.day6_hr1 * -1  AS 'Sat',
						D.day7_hr1 * -1  AS 'Sun',
						LTRIM(RTRIM(F.customer)) AS 'Client_ID', 
						LTRIM(RTRIM(F.pm_id02)) AS 'Product_ID',
						LTRIM(RTRIM(d.project)) AS 'Project_ID',
						LTRIM(RTRIM(A.emp_name)) AS 'Emp_Name',
						LTRIM(RTRIM(A.emp_status)) AS 'Emp_Status', 
						LTRIM(RTRIM(CC.le_status)) AS 'TC_Status',
						LTRIM(RTRIM(B.PayType)) AS 'Emp_Pay_Type',
						B.effect_date AS 'Effective_Date', 
						LTRIM(RTRIM(A.employee)) AS 'Emp_ID', 
						0 AS 'PTOHours', 
						LTRIM(RTRIM(F.project_desc)) AS 'Project_Desc',
						LTRIM(RTRIM(CC.docnbr)) AS 'Docnbr', 
						CASE
							WHEN SUBSTRING(A.em_id02, 5, 27) = '' THEN 'MISSING'
							ELSE SUBSTRING(A.em_id02, 5, 27)
						END AS 'ADPFileID', 
						CASE
							WHEN LEFT(A.em_id02, 3) = '' THEN 'MISSING'
							ELSE LEFT(A.em_id02, 3)
						END AS 'PayGroup',
						LTRIM(RTRIM(G.Name)) AS 'Client',
						COALESCE(LTRIM(RTRIM(H.code_value_desc)),'') AS 'Product', 
						ISNULL(LTRIM(RTRIM(A.gl_subacct)),'') AS 'Dept_ID',
						COALESCE(LTRIM(RTRIM(I.Descr)),'') AS 'Department',
						ISNULL(NULLIF(COALESCE(LTRIM(RTRIM(A.em_id16)),'TX'), ''), 'TX')  AS 'WorkStateID',
						ISNULL(NULLIF(COALESCE(LTRIM(RTRIM(J.Descr)),'Texas'), ''), 'Texas') AS 'WorkState',
						CC.lupd_datetime AS 'Last_Update',
						'Corrected' AS 'Timecard_Type'
			FROM		DALLASSTUDIOAPP.dbo.PJEMPLOY A INNER JOIN
						DALLASSTUDIOAPP.dbo.PJLABHDR C ON A.employee = C.employee INNER JOIN
						(SELECT	subTable.docnbr,
								subTable.effect_date,
								X1.ep_id05 AS PayType
						FROM	DALLASSTUDIOAPP.dbo.PJEMPPJT AS X1 RIGHT OUTER JOIN
								(SELECT		X3.docnbr,
											X3.employee,
											MAX(X2.effect_date) AS 'effect_date'
								FROM		DALLASSTUDIOAPP.dbo.PJEMPPJT AS X2 RIGHT OUTER JOIN
											DALLASSTUDIOAPP.dbo.PJLABHDR AS X3 ON X2.employee = X3.employee AND X2.effect_date <= X3.pe_date
								GROUP BY	X3.docnbr, X3.employee) AS subTable ON  X1.employee = subTable.employee AND X1.effect_date = subTable.effect_date) B ON B.docnbr = C.docnbr LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.PJLABHDR CC ON C.docnbr = CC.le_key INNER JOIN
						DALLASSTUDIOAPP.dbo.PJLABDET D ON C.docnbr = D.docnbr LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.PJEMPLOY E ON E.employee = C.Approver LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.PJPROJ F ON D.project = F.project LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.Customer G ON F.customer = G.CustId LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.PJCODE H ON F.pm_id02 = H.code_value AND H.code_type = 'BCYC' LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.SubAcct I ON A.gl_subacct = I.Sub LEFT OUTER JOIN
						DALLASSTUDIOAPP.dbo.State J ON A.em_id16 = J.StateProvId	
			WHERE		C.le_status = 'X'
						AND CC.le_status IN ('P','X')
						AND CC.le_type = 'C') AS Tbl
inner join @EmpPayType empt
	on tbl.Emp_Pay_Type = coalesce(empt.EmpPayType, tbl.Emp_Pay_Type)
inner join @Agency agy
	on tbl.Agency = coalesce(agy.Agency, tbl.Agency)
WHERE (PayGroup IN (@sPayGroup) OR @sPayGroup IS NULL OR PayGroup = 'MISSING')
			AND (Emp_ID IN (@sEmp_ID) OR @sEmp_ID IS NULL)
			AND Last_Update BETWEEN @begin AND @end
			
GROUP BY	tbl.Agency,
			Approver,
			Emp_ID,
			Emp_Name,
			Period_End_Date,
			Emp_Status,
			Emp_Pay_Type,
			Effective_Date,
			Dept_ID,
			Department,
			Project_ID,
			Project_Desc,
			Client_ID,
			Product_ID,
			WorkStateID,
			WorkState,
			PayGroup,
			ADPFileID,
			TC_Status,
			Last_Update,
			Timecard_Type,
			Docnbr
HAVING		(SUM(Mon) <> 0 OR SUM(Tue) <> 0 OR SUM(Wed) <> 0 OR SUM(Thr) <> 0 OR SUM(Fri) <> 0 OR SUM(Sat) <> 0 OR SUM(Sun) <> 0)
ORDER BY	Emp_ID, Period_End_Date, Docnbr, Project_ID		



---------------------------------------------
-- permissions
---------------------------------------------
grant execute on PayrollGet to BFGROUP
go

grant execute on PayrollGet to MSDSL
go

grant control on PayrollGet to MSDSL
go

grant execute on PayrollGet to MSDynamicsSL
go