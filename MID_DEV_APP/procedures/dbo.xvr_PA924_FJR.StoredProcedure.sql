USE [MID_DEV_APP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITHwith (nolock)
            WHERE NAME = 'xvr_PA924_FJR'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[xvr_PA924_FJR]
GO

CREATE PROCEDURE [dbo].[xvr_PA924_FJR]     
     
AS

/*******************************************************************************************************
*	MID_DEV_APP.dbo.xvr_PA924_FJR.sql
*
*   Notes:  Account Leadership FJR Report - This does the same thing as the query in the SSRS report
			for this. Reformatted into a procedure and tuned it, though, to trouble shoot the discrepancies
			mentioned in #43811 (among other tickets)

	execute MID_DEV_APP.dbo.xvr_PA924_FJR

*                  
*   Modifications:   
*   Name				Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
-- For internal reporting use
DECLARE @CurrentDate Date	--Would have been used in used in WIP AGING logic
DECLARE @iYear as int

---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##FJR') > 0 drop table ##FJR
create table ##fjr
(
	Project varchar(16) primary key clustered,
	OpenPO float,
	Actuals float,
	BTD float
)

if object_id('tempdb.dbo.##cle') > 0 drop table ##cle
create table ##cle
(
	Project varchar(16) primary key clustered,
	CLEFee float,
	CLEAmount float
)

if object_id('tempdb.dbo.##trv') > 0 drop table ##trv
create table ##trv
(
	project varchar(16) primary key clustered,
	TravActuals float
)

if object_id('tempdb.dbo.##oop') > 0 drop table ##oop
create table ##oop
(
	project varchar(16) primary key clustered,
	OOPActuals float
)

if object_id('tempdb.dbo.##RptWIP') > 0 drop table ##RptWIP
create table ##RptWIP
(
	project varchar(16) primary key clustered,
	WIPOvr60Amount float
)

if object_id('tempdb.dbo.##projectHrs') > 0 drop table ##projectHrs
create table ##projectHrs
(
	project varchar(16) primary key clustered,
	TTLHrs float
)

if object_id('tempdb.dbo.##ip') > 0 drop table ##ip
create table ##ip
(
	project varchar(16) primary key clustered
)
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------

--DECLARE @iMonth as char(2)
--DECLARE @EndPerNbr as char(6)
SET @CurrentDate = getdate()
SET @iYear = YEAR(@CurrentDate)

-- remove later
DECLARE @sProject varchar(100)
DECLARE @sclientId  varchar(100)
DECLARE @sclientPO  varchar(100)
DECLARE @sProductId  varchar(100)
DECLARE @sPM  varchar(100)
DECLARE @sStatus  varchar(100)
select @sProject = null
select @sclientId = null
select @sclientPO = null
select @sProductId = null
select @sPM = null
select @sStatus = null
-----

insert ##fjr
(
	Project,
	OpenPO,
	Actuals,
	BTD
)
SELECT Project,
	OpenPO = coalesce((Max(ExtCost) - Max(CostVouched)),0), 
	--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
	Actuals = SUM (CASE WHEN AcctGroupCode IN ('WA','WP','CM','FE') THEN
							AmountBF + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15
						ELSE 0  
					END),						--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
	BTD = SUM (CASE WHEN ControlCode = 'BTD' OR AcctGroupCode = 'PB' THEN
						AmountBF + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15
					ELSE 0 
				END)
 
From MID_DEV_APP.dbo.xvr_PA924_Main with (nolock)	
Where FSYearNum = @iYear 
Group by Project

insert ##cle
(
	Project,
	CLEFee,
	CLEAmount
)
Select CLE.Project, 
	CLEFee = SUM(CASE WHEN (FC.code_group = 'FEE' and FC.code_ID <> '00975') THEN CLE.CLEAmount ELSE 0 END), 
	CLEAmount = SUM(CLE.CLEAmount) 
From MID_DEV_APP.dbo.xvr_Est_CLE CLE with (nolock)
INNER JOIN MID_DEV_APP.dbo.xIGFunctionCode FC with (nolock)
	ON CLE.pjt_entity = FC.code_ID
Group by CLE.Project

insert ##trv
(
	project,
	TravActuals
)
SELECT project,
	TRAVActuals = sum(Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15)
FROM MID_DEV_APP.dbo.xvr_BU96C_Actuals with (nolock)
where [Function] in (select code_ID 
						from MID_DEV_APP.dbo.xIGFunctionCode with (nolock)
						where code_group = 'TRAV') 
	and acct = 'Billable'
group by project

insert ##oop
(
	project,
	OOPActuals
)
SELECT project,
  OOPActuals = sum(Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15)
FROM MID_DEV_APP.dbo.xvr_BU96C_Actuals with (nolock)				
where [Function] in (select code_ID 
					from MID_DEV_APP.dbo.xIGFunctionCode with (nolock)
					where code_group NOT IN ('TRAV','FEE') 
						or code_id = '00975') 
	and acct IN ('Billable','BILLABLE APS','BILLABLE FEES') 
group by project

insert ##RptWIP
(
	project,
	WIPOvr60Amount
)
SELECT d.project,
	WIPOvr60Amount = SUM(CASE WHEN d.li_type NOT IN ('D', 'A') AND DateDiff(day, d.source_trx_date, GETDATE() /*@CurrentDate*/ ) >60 THEN d.amount
							ELSE 0
						END) 							
FROM MID_DEV_APP.dbo.PJINVDET d with (nolock)
LEFT JOIN MID_DEV_APP.dbo.PJINVHDR h with (nolock)
	ON d.draft_num = h.draft_num
INNER JOIN MID_DEV_APP.dbo.PJPROJ p with (nolock)
	ON d.project = p.project 
INNER JOIN MID_DEV_APP.dbo.PJACCT a with (nolock) 
	ON d.acct = a.acct
WHERE d.hold_status <> 'PG' 
	AND d.bill_status <> 'B'
	AND a.acct_group_cd NOT IN ('CM', 'FE')
	AND p.project NOT IN (SELECT JobID 
							FROM MID_DEV_APP.dbo.xWIPAgingException with (nolock))
	AND (substring(d.acct, 1, 6) <> 'OFFSET' 
		OR d.acct = 'OFFSET PREBILL')
Group By d.project	

insert ##projectHrs
(
	project,
	TTLHrs
)
SELECT project,
	TTLHrs = SUM(units)  --PJTRAN.units AS Hrs
FROM MID_DEV_APP.dbo.PJTRAN with (nolock) 
WHERE acct = 'LABOR'
Group By Project	

insert ##ip (project)
SELECT Project 
FROM MID_DEV_APP.dbo.PJPROJ with (nolock)
WHERE contract_type IN('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','TIME','NYK')

--Main Query
select Company = 'DENVER', 
	Project = ltrim(rtrim(p.Project)),
	[Status] = CASE WHEN p.status_pa = 'I' THEN 'INACTIVE' ELSE 'ACTIVE' END, 
	project_billwith = ltrim(rtrim(b.project_billwith)),
	ClientID = ltrim(rtrim(p.pm_id01)),
	ClientName = coalesce(ltrim(rtrim(c.[name])),'Customer Name Unavailable'), 
	ProductID = ltrim(rtrim(p.pm_id02)),  
	ProductDesc = ltrim(rtrim(pc.descr)), 
	PM = ltrim(rtrim(p.manager1)),
	AcctService = ltrim(rtrim(p.manager2)),
	Project_Desc = ltrim(rtrim(p.Project_Desc)), 
	ClientContact = ltrim(rtrim(xc.CName)),
	ContactEmailAddress = ltrim(rtrim(xc.EmailAddress)),  
	ClientRefNo = ltrim(rtrim(p.purchase_order_num)), 
	ECD = ltrim(rtrim(x.pm_id28)), 
	OnShelfDate = ltrim(rtrim(p.end_date)), 
	[Final On-Shelf Date] = CASE WHEN x.pm_id28 = '' THEN p.end_date ELSE ltrim(rtrim(x.pm_id28)) END, 
	CloseDate = ltrim(rtrim(p.pm_id08)), 
	OfferNum = ltrim(rtrim(p.pm_id32)), 
	ULEAmount = coalesce(ULE.ULEAmount, 0), 
	CLEAmount = coalesce(CLE.CLEAmount, 0), 
	CLEFeeAmount = coalesce(CLE.CLEFee, 0), 
	TRVActuals = coalesce(TRV.TRAVActuals, 0), 
	OOPActuals = coalesce(OOP.OOPActuals, 0), 
	OpenPO = coalesce(FJR.OpenPO, 0), 
	ActualsToBill = CASE WHEN coalesce(FJR.Actuals, 0) - coalesce(FJR.BTD, 0) < 0 THEN 0 ELSE coalesce(FJR.Actuals, 0) - coalesce(FJR.BTD, 0) END, 
	BTD = coalesce(FJR.BTD, 0),
	WIPOver60Amount = coalesce(RptWIP.WIPOvr60Amount, 0),  --Period Sensitive being removed
	ProjectHours = coalesce(ProjectHrs.TTLHrs, 0),
	ContractType = CASE WHEN p.contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','NYK') THEN 'PROD'
						WHEN p.contract_type = 'TIME' THEN 'TIME'
					  END,
	ProjectStatus = p.status_pa, 
	-- Filtering fields required when adding logic for all parent child to return when either is pulled.
	FltClientPO = p.purchase_order_num
From  ##ip ip --!!!!!! ALL FILTER CRITERIA MUST BE ON IP AND NOT P OR PARENT CHILD JOBS WILL NOT ALWAYS BE PULLED TOGETHER!!!!!!
INNER JOIN MID_DEV_APP.dbo.PJBILL A with (nolock)
	ON ip.Project = A.Project
INNER JOIN MID_DEV_APP.dbo.PJBILL B with (nolock)
	ON A.project_billwith = B.project_billwith 
INNER JOIN MID_DEV_APP.dbo.PJPROJ p with (nolock)
	ON b.project = p.project
LEFT OUTER JOIN MID_DEV_APP.dbo.xIGProdCode pc with (nolock)
	ON p.pm_id02 = pc.code_ID
LEFT OUTER JOIN MID_DEV_APP.dbo.CUSTOMER c with (nolock)
	ON p.pm_id01 = C.CustId
LEFT OUTER JOIN MID_DEV_APP.dbo.PJPROJEX x with (nolock)
	ON p.project = x.project
LEFT JOIN MID_DEV_APP.dbo.xClientContact xc with (nolock)
	ON p.user2 = xc.EA_ID
LEFT OUTER JOIN ##fjr fjr --FJR query.  To get down to one line for reporting pulling as main source
	ON p.project = FJR.Project	--END FJR query
LEFT OUTER JOIN MID_DEV_APP.dbo.xvr_Est_ULE_Project ULE with (nolock) --Unlocked Estimate view by project				
	ON p.Project = ULE.Project
LEFT OUTER JOIN ##cle CLE /*(Using Current Locked Estimate view with functions.  Must roll up to project or cartestion joins */
	ON p.Project = CLE.Project
LEFT OUTER JOIN ##trv TRV /*(Using Travel with functions.  Must roll up to project or cartestion joins */ -- Get the Travel Actuals
	ON p.Project = TRV.Project
LEFT OUTER JOIN ##oop OOP /*(Using Out Of Pocket functions. This is all functions except TRAV and FEE Must roll up to project or cartestion joins */ -- Get the Out of Pocket Actuals
	ON p.Project = OOP.Project			   
LEFT OUTER JOIN ##RptWIP RptWIP /*(Logic taken from BI902 and stripped down.  Including aging days for reuse*/	   
--Per Email, include all WIP transactions.  Leaving in as easy to uncomment if decisions change.
	ON p.Project = RptWip.project
	/*  END WIP QUERY */
LEFT OUTER JOIN ##projectHrs ProjectHrs --Time query taken from Client P&L
	ON p.Project = ProjectHrs.Project
--END Time Query
Where ltrim(rtrim(b.project_billwith)) <> ''
	and p.project = '05443413AGY'
--	and p.pm_id01 = '1A2MK'
/*
	AND (ltrim(rtrim(p.Project)) IN (@sProject) 
			OR @sProject IS NULL)
	AND ltrim(rtrim(p.pm_id01)) IN (@sClientID)
	AND (p.purchase_order_num IN (@sClientPO) 
			OR @sClientPO IS NULL)
	AND ltrim(rtrim(p.pm_id02)) IN (@sProductID)
	AND ltrim(rtrim(p.manager1)) IN (@sPM)
	AND p.status_pa IN (@sStatus)
*/
group by ltrim(rtrim(p.Project)),
	ltrim(rtrim(b.project_billwith)),
	ltrim(rtrim(p.pm_id01)),
	coalesce(ltrim(rtrim(c.[name])),'Customer Name Unavailable'), 
	ltrim(rtrim(p.pm_id02)),  
	ltrim(rtrim(pc.descr)), 
	ltrim(rtrim(p.manager1)),
	ltrim(rtrim(p.manager2)),
	ltrim(rtrim(p.Project_Desc)), 
	ltrim(rtrim(xc.CName)),
	ltrim(rtrim(xc.EmailAddress)),  
	ltrim(rtrim(p.purchase_order_num)), 
	ltrim(rtrim(x.pm_id28)), 
	ltrim(rtrim(p.end_date)), 
	CASE WHEN x.pm_id28 = '' THEN p.end_date ELSE ltrim(rtrim(x.pm_id28)) END, 
	ltrim(rtrim(p.pm_id08)), 
	ltrim(rtrim(p.pm_id32)), 
	coalesce(ULE.ULEAmount, 0), 
	coalesce(CLE.CLEAmount, 0), 
	coalesce(CLE.CLEFee, 0), 
	coalesce(TRV.TRAVActuals, 0), 
	coalesce(OOP.OOPActuals, 0), 
	coalesce(FJR.OpenPO, 0), 
	CASE WHEN coalesce(FJR.Actuals, 0) - coalesce(FJR.BTD, 0) < 0 THEN 0 ELSE coalesce(FJR.Actuals, 0) - coalesce(FJR.BTD, 0) END, 
	coalesce(FJR.BTD, 0),
	coalesce(RptWIP.WIPOvr60Amount, 0),  --Period Sensitive being removed
	p.purchase_order_num,
	coalesce(ProjectHrs.TTLHrs, 0),
	CASE WHEN p.contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','NYK') THEN 'PROD'
						WHEN p.contract_type = 'TIME' THEN 'TIME'
					  END,
	 p.status_pa
Order by ltrim(rtrim(p.manager1)), ltrim(rtrim(p.pm_id01)), ltrim(rtrim(p.pm_id02)),ltrim(rtrim(p.Project)), 
	CASE WHEN p.contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','NYK') THEN 'PROD'
		WHEN p.contract_type = 'TIME' THEN 'TIME'
	END
	
drop table ##fjr
drop table ##cle
drop table ##trv
drop table ##oop
drop table ##RptWIP
drop table ##projectHrs
drop table ##ip





/*
select *
from ##test
where project = '06802415AGY'

drop table ##test

alter table ##test 
alter column project varchar(16) not null

alter table ##test add primary key clustered (project)

execute MID_DEV_APP.dbo.xvr_PA924_FJR
*/
---------------------------------------------
-- permissions
---------------------------------------------
grant execute on xvr_PA924_FJR to BFGROUP
go

grant execute on xvr_PA924_FJR to MSDSL
go

grant control on xvr_PA924_FJR to MSDSL
go

grant execute on xvr_PA924_FJR to MSDynamicsSL
go
