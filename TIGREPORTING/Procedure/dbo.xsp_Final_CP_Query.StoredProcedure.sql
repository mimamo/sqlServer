USE [TIGREPORTING]
GO
/****** Object:  StoredProcedure [dbo].[xsp_Final_CP_Query]    Script Date: 02/29/2016 13:54:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/* =============================================
-- Author:		Dan Bertram
-- Create date: 3/25/2014
-- Description:	Procedure to save CP Data into 
--              xCPDataAll table for the SSRS
--				report.
--Modified on 7/8/14 by KW, removed '19INTCOB' from exclusion criteria on allocations'
-- Modified on 7/23/14 by Kathryn Wallace  Added Major Profit Center to provide additional grouping per Jill Picard
-- Modified in 2015-02 to add ShopperNY and to only delete periods that are being added.
-- Maajor modifications in 2015-04 and 05 to accomodate Shopper, remove Severance and make processing more transparent

execute TIGREPORTING.dbo.xsp_Final_CP_Query '201601', '201601'
-- ============================================= */

ALTER PROCEDURE [dbo].[xsp_Final_CP_Query] (
    @begPeriod int, @endPeriod int)
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
exec [TIGREPORTING].[dbo].[xsp_CP_Totals_Query] 
   @begPeriod
  ,@endPeriod
-- Set debugging Variables
/*
declare @begPeriod as varchar(6)
declare @endPeriod as varchar(6)
set @begPeriod = '201501'
set @endPeriod = '201501'
*/
----Check the Variables


/********************************************************************************/
/*                           DIRECT ALLOCATIONS Section                         */
/********************************************************************************/


-- Delete Data from the data table where the period = the period run
delete from TIGREPORTING.dbo.xCPDataAll 
where fiscalno  >= @BegPeriod  
    AND fiscalno <= @EndPeriod 

----ADD THE DIRECT ALLOCATIONS
--ADD THE HOURS PER CLIENT
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
    ClassId, 
    ClassDesc, 
    CustId, 
    CustName,
    acct_type, 
    acct, 
    Total, 
    fiscalno, 
    ProfitCenter, 
    MajorProfitCenter, 
    [Hours], 
    Project, 
    Sub
)
SELECT CP_Type, 
	R_Group = 'HOURS', 
	Sort = '20', 
	ReportSort = 'Direct Hours', 
	ClassGroup,
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId,
	CustName, 
	acct_type = 'HRS', 
	acct, 
	TTLHrs Total, 
	FiscalPeriod, 
	PCenter, 
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end,  
	TTLHrs, 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
where CP_Type = 'DIRECT' 
	AND FiscalPeriod between @begPeriod and @endPeriod 
 

--ADD THE DIRECT WAGES
Insert into TIGREPORTING.dbo.xCPDataAll
 (
	[Type],
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	Project, 
	Sub
)
SELECT l.CP_Type, 
	CP_Group = 'WAGES', 
	Sort = '04', 
	ReportSort = 'Direct Wages', 
	l.ClassGroup, 
	l.GroupDesc, 
	l.ClassId, 
	l.ClassDesc, 
	l.CustId, 
	l.CustName, 
	acct_type = 'EX', 
	l.acct, 
	Total = (l.TTLHrs * e.HRLRate) * -1, 
	l.FiscalPeriod, 
	l.PCenter, 
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	l.Project, 
	l.gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor l with (nolock)
INNER JOIN TIGREPORTING.dbo.xEmpInfo e with (nolock)
  ON l.employee = e.UserID 
  AND l.FiscalPeriod = e.FiscalPeriod
where l.FiscalPeriod between  @begPeriod and @endPeriod 
--AND TransPeriod <= @endPeriod
	and l.CP_Type = 'DIRECT'

--ADD THE DIRECT WAGES PAYROLL EXPENSES
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	Project, 
	Sub
)
SELECT l.[Type], 
	l.ReportGroup, 
	Sort = '05', 
	ReportSort = 'Direct Wages Payroll Expenses', 
	l.ClassGroup, 
	l.GroupDesc, 
	l.ClassId, 
	l.ClassDesc, 
	l.CustId, 
	l.CustName, 
	acct_type = 'EX', 
	l.acct, 
	Total = (Total * t.TotTaxrate), 
	l.fiscalno, 
	l.ProfitCenter, 
	MajorProfitCenteer = case when l.ProfitCenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	l.Project, 
	l.sub
FROM TIGREPORTING.dbo.xCPDataAll l with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T with (nolock)
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where l.fiscalno between @begPeriod and @endPeriod 
	and ReportSort = 'Direct Wages'


--ADD THE DIRECT REVENUE ALLOCATIONS
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc,
    ClassId, 
    ClassDesc, 
    CustId, 
    CustName, 
    acct_type, 
    acct, 
    Total, 
    fiscalno, 
    ProfitCenter, 
    MajorProfitCenter, 
    [Hours], 
    Project, 
    Sub
   )
SELECT CP_Type, 
	CP_Group, 
	Sort = CASE WHEN acct = 'Project Revenue' THEN '01' 
				WHEN acct = 'Retained Revenue' THEN '02'
				ELSE '03' 
			END, 
	ReportSort = acct, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Amount, 
	perpost, 
	PCenter, 
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end,
	[Hours] = 0, 
	project, 
	sub
FROM TIGREPORTING.dbo.xvw_CPData with (nolock)
where perpost between @begPeriod and @endPeriod 
 --AND CP_Type = 'DIRECT'   --Removed 4/27/2015 to bring in Shopper projects with no number
  and CP_Group NOT IN ('LABOR') 
  AND CP_Group = 'REVENUE'


--ADD THE DIRECT ALLOCATIONS (SEA, LEGAL, RENT)
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort,
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
    CustId, 
    CustName, 
    acct_type, 
    acct, 
    Total, 
    fiscalno, 
    ProfitCenter, 
    MajorProfitCenter,
    [Hours], 
    Project, 
    Sub
)
SELECT CP_Type, 
	CP_Group,
	Sort = CASE WHEN CP_Group = 'SEA' THEN '09' 
				WHEN CP_Group = 'RENT' THEN '11'
				WHEN CP_Group = 'LEGAL' THEN '14'
			END,
	ReportSort = CASE WHEN CP_Group = 'SEA' THEN 'SEA' 
					WHEN CP_Group = 'RENT' THEN 'Direct Rent Expense'
					WHEN CP_Group = 'LEGAL' THEN 'Legal Expense'
				END,
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total = Amount * -1, 
	perpost, 
	PCenter,
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	project, 
	sub
FROM TIGREPORTING.dbo.xvw_CPData with (nolock)
where perpost between @begPeriod and @endPeriod 
--AND CP_Type = 'DIRECT' 
	and CP_Group NOT IN ('LABOR','REVENUE') 

--ADD THE DONOVAN ALOCATIONS 
--ADD THE OVERHEAD ALLOCATIONS
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	project,
	sub
)
SELECT [Type] = 'DIRECT', 
	ReportGroup = 'DONOVAN', 
	Sort = '13', 
	ReportSort = 'Donovan Expense', 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId,
	CustName, 
	acct_type = 'EX', 
	acct = 'DONOVAN', 
	Total = ((TTLHrs/T.TotDonHours)* T.TotDonovan) * -1, 
	FiscalPeriod, 
	PCenter,
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T with (nolock)
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where FiscalPeriod between @begPeriod and @endPeriod
--AND TransPeriod <= @endPeriod
	AND ClassGroup IN (select distinct ClassGroup 
						from TIGREPORTING.dbo.xDonovanLookUp with (nolock))

/********************************************************************************/
/*                           INDIRECT ALLOCATIONS Section                       */
/********************************************************************************/

-----INDIRECT ALLOCATIONS
--ADD THE INDIRECT HOURS ALLOCATIONS
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	project, 
	sub
)
SELECT [Type] = 'INDIRECT', 
	ReportGroup = 'HOURS', 
	Sort = '21', 
	ReportSort = 'Indirect Hours', 
	ClassGroup, 
	GroupDesc,
	ClassId, 
	ClassDesc,
	CustId,
	CustName, 
	acct_type = 'HRS', 
	acct = 'HOURS', 
	Total = ((TTLHrs/T.TotHours) * T.TotIndirectHours), 
	FiscalPeriod, 
	PCenter, 
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end,
	[Hours] = ((TTLHrs/T.TotHours)*T.TotIndirectHours), 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T with (nolock)
	on BegPeriodNo = @begPeriod and EndPeriodNo = @endPeriod
where FiscalPeriod between @begPeriod and @endPeriod 
--AND TransPeriod <= @endPeriod
and ClassGroup NOT IN ('40DGEN')

--ADD THE OVERHEAD ALLOCATIONS
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	project, 
	sub
)
SELECT [Type] = 'INDIRECT', 
	ReportGroup = 'OVERHEAD', 
	Sort = '16', 
	ReportSort = 'Indirect Overhead Expense', 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId,
	CustName, 
	acct_type = 'EX', 
	acct = 'OVERHEAD', 
	Total = ((TTLHrs/T.TotHours) * T.TotOverhead) * -1, 
	FiscalPeriod, 
	PCenter, 
	MajorProfitCenter = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T with (nolock)
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where FiscalPeriod between @begPeriod and @endPeriod
--AND TransPeriod <= @endPeriod
	and ClassGroup  NOT IN ('40DGEN')


--ADD THE INDIRECT SEA ALLOCATIONS 
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc,
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	project, 
	sub
)
SELECT [Type] = 'INDIRECT', 
	ReportGroup = 'SEA', 
	Sort = '10', 
	ReportSort = 'Indirect SEA', 
	ClassGroup, 
	GroupDesc,
	ClassId, 
	ClassDesc, 
	CustId,
	CustName, 
	acct_type = 'EX', 
	acct = 'SEA', 
	Total = ((TTLHrs/T.TotHours) * T.TotIndirectSEA) * -1, 
	FiscalPeriod, 
	PCenter, 
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T 
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where FiscalPeriod between @begPeriod and @endPeriod 
--AND TransPeriod <= @endPeriod
	and ClassGroup  NOT IN ('40DGEN')

--ADD THE INDIRECT RENT ALLOCATIONS
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type,
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	project, 
	sub
)
SELECT [Type] = 'INDIRECT', 
	ReportGroup = 'RENT', 
	Sort = '12', 
	ReportSort = 'Indirect Rent Expense', 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId,
	CustName, 
	acct_type = 'EX', 
	acct = 'RENT', 
	Total = ((TTLHrs/T.TotHours) * T.TotRent) * -1, 
	FiscalPeriod, 
	PCenter,
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T with (nolock)
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where FiscalPeriod between @begPeriod and @endPeriod
--AND TransPeriod <= @endPeriod
and ClassGroup  NOT IN ('40DGEN')

--ADD THE INDIRECT INTEREST ALLOCATIONS
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	project, 
	sub
)
SELECT [Type] = 'INDIRECT', 
	ReportGroup = 'INTEREST', 
	Sort = '15', 
	ReportSort = 'Interest Expense', 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId,
	CustName, 
	acct_type = 'EX', 
	acct = 'INTEREST', 
	Total = ((TTLHrs/T.TotHours) * T.TotInterest) * -1, 
	FiscalPeriod, 
	PCenter,
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T 
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where FiscalPeriod between @begPeriod and @endPeriod 
--AND TransPeriod <= @endPeriod
 and ClassGroup  NOT IN ('40DGEN')

--ADD THE ALLOCATIONS FOR PRO BONO, SISTER AGENCIES AND NEW BUSINESS EXPENSES
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum,
	ReportSort,
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type, 
	acct, 
	Total, 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenter, 
	[Hours], 
	project, 
	sub
)
SELECT CP_Type, 
	ReportGroup = 'PSNB', 
	Sort = '08', 
	ReportSort = 'Pro Bono - Sister Agencies - New Business', 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId,
	CustName, 
	acct_type = 'EX', 
	acct = 'PSNB', 
	Total = ((TTLHrs/T.TotHours)*T.TotPRO_SIS_NEW) + (((TTLHrs/T.TotHours) * T.TotPRO_SIS_NEW) * T.TotTaxRate), 
	FiscalPeriod, 
	PCenter, 
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end, 
	[Hours] = 0, 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T with (nolock)
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where FiscalPeriod between @begPeriod and @endPeriod 
--AND TransPeriod <= @endPeriod
	and ClassGroup  NOT IN ('40DGEN')

-- Get Indirect Wages Total for Allocation
Declare @IndirectWages float

select @IndirectWages = (max(T.TotWages) + sum(Total) + max(T.TotPRO_SIS_NEW)) + max(T.TotOtherComp)
from TIGREPORTING.dbo.xCPDataAll with (nolock)
inner join xCPTotals T 
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where ReportSort IN ('Direct Wages') 
	and fiscalno between @begPeriod and @endPeriod 

--select @IndirectWages = (@TotalWages + SUM(Total) + @PRO_SIS_NEW) + @OtherComp
--from TIGREPORTING.dbo.xCPDataAll 
--where ReportSort IN ('Direct Wages') and fiscalno between @begPeriod and @endPeriod 

-- Check variables after update
--print 'IndirectWages: '
--print @IndirectWages

--ADD THE INDIRECT WAGES 
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc,
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type,
    acct, 
    Total, 
    fiscalno, 
    ProfitCenter, 
    MajorProfitCenter, 
    [Hours], 
    project, 
    sub
)
SELECT CP_Type, 
	ReportGroup = 'LABOR', 
	Sort = '06', 
	ReportSort = 'Indirect Wages', 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId,
	CustName, 
	acct_type = 'EX', 
	acct = 'LABOR', 
	Total = ((TTLHrs/T.TotHours)*@IndirectWages) * -1, 
	FiscalPeriod, 
	PCenter, 
	MajorProfitCenteer = case when pcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end,
	[Hours] = 0, 
	project, 
	gl_subacct
FROM TIGREPORTING.dbo.xvw_Labor with (nolock)
inner join TIGREPORTING.dbo.xCPTotals T with (nolock)
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where FiscalPeriod between @begPeriod and @endPeriod 
--AND TransPeriod <= @endPeriod
and ClassGroup  NOT IN ('40DGEN')

--ADD THE INDIRECT WAGES PAYROLL EXPENSES
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc,
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName,
    acct_type, 
    acct, 
    Total, 
    fiscalno, 
    ProfitCenter, 
    MajorProfitCenter, 
    [Hours], 
    project, 
    sub)
SELECT [Type] = 'INDIRECT', 
	CP_Group = 'LABOR', 
	Sort = '07',  
	ReportSort = 'Indirect Wages Payroll Expenses',
	l.ClassGroup, 
	l.GroupDesc, 
	l.ClassId, 
	l.ClassDesc, 
	l.CustId, 
	l.CustName, 
	acct_type = 'EX', 
	l.acct, 
	Total = (Total * T.TotTaxRate), 
	l.fiscalno, 
	l.ProfitCenter,
	MajorProfitCenteer = case when profitcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end,
	[Hours] = 0, 
	project, 
	sub
FROM TIGREPORTING.dbo.xCPDataAll l 
inner join TIGREPORTING.dbo.xCPTotals T 
	on BegPeriodNo = @begPeriod 
	and EndPeriodNo = @endPeriod
where l.fiscalno between @begPeriod and @endPeriod 
	and ReportSort = 'Indirect Wages'


-- Create rows for Expense Profit, Profit Margin, FTE, and Rev per FTE
---- Add Expense Row
Insert into TIGREPORTING.dbo.xCPDataAll
(
	[Type], 
	ReportGroup, 
	ReportSortNum, 
	ReportSort, 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type,
	acct, 
    Total, 
    fiscalno, 
    ProfitCenter, 
    MajorProfitCenter, 
    [Hours], 
    project, 
    sub
)
SELECT [Type] = 'INDIRECT', 
	CP_Group = 'EXPENSE', 
	Sort = '17', 
	ReportSort = 'Expense', 
	ClassGroup, 
	GroupDesc, 
	ClassId, 
	ClassDesc, 
	CustId, 
	CustName, 
	acct_type = 'TOTEX', 
	acct, 
	Total = (Total), 
	fiscalno, 
	ProfitCenter, 
	MajorProfitCenteer = case when profitcenter IN ('APS', 'ICP') then 'EG+' ELSE 'DENVER' end,
	[Hours] = 0, 
	project, 
	sub
FROM TIGREPORTING.dbo.xCPDataAll with (nolock)
where fiscalno between @begPeriod and @endPeriod 
	and acct_type = 'EX'

END


--EXEC TIGREPORTING.dbo.xsp_Final_CP_Query '201401','201401'



