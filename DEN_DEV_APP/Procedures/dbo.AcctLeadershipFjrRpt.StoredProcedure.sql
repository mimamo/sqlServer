USE DEN_DEV_APP; 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'AcctLeadershipFjrRpt'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[AcctLeadershipFjrRpt]
GO

CREATE PROCEDURE [dbo].[AcctLeadershipFjrRpt]     
	@Company varchar(30),
	@sProject varchar(20) = '',
	@sClientID varchar(30) = '',
	@sClientPO varchar(20) = '',
	@sProductID varchar(20) = '',
	@sPM varchar(10) = '',
	@sStatus varchar(1) = ''
	
 AS


/*******************************************************************************************************
*   DEN_DEV_APP.dbo.AcctLeadershipFjrRpt 
*
*   Creator:   
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:	
	
		execute DEN_DEV_APP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sProject = '06388515NYC', @sClientId = '1LFSU', @sProductId = 'TRDE', @sPM = 'SAPPEL', @sStatus = 'A'
		execute DEN_DEV_APP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sClientId = '1JJVC', @sProductId = 'CUST', @sPM = 'CUST', @sStatus = 'A'
		execute DEN_DEV_APP.dbo.AcctLeadershipFjrRpt @company = 'DENVER', @sClientId = '1IZZE', @sProductId = 'IZZE', @sPM = 'ALUU', @sStatus = 'A'
		

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	01/27/2016	Put query from SSRS into procedure
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
-- For internal reporting use
DECLARE @CurrentDate Date	--Would have been used in used in WIP AGING logic
DECLARE @iYear as int

SET @CurrentDate = getdate()
SET @iYear = YEAR(@CurrentDate)

declare @sql nvarchar(max)
declare @sql1 nvarchar(max)
declare @sql2 nvarchar(max)
declare @sql3 nvarchar(max)
declare @serverName varchar(13)
declare @dbName nvarchar(24)
---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##fjrResults') > 0 drop table ##fjrResults
create table ##fjrResults
(
	Company varchar(10),
	Project varchar(16), 
	[Status] varchar(10),  
	project_billwith varchar(16), 
	ClientID varchar(30), 
	ClientName varchar(60), 
	ProductID varchar(30), 
	ProductDesc varchar(30), 
	PM varchar(10), 
	AcctService varchar(10), 
	Project_Desc varchar(60), 
	ClientContact varchar(30), 
	ContactEmailAddress varchar(50),
	ClientRefNo varchar(20),
	ECD datetime, 
	OnShelfDate datetime, 
	[Final On-Shelf Date] datetime,
	CloseDate datetime, 
	OfferNum varchar(30), 
	ULEAmount float, 
	CLEAmount float, 
	CLEFeeAmount float, 
	TRVActuals float, 
	OOPActuals float, 
	OpenPO float,  
	Actuals float,   
	ActualsToBill float, 
	BTD float, 
	WIPOver60Amount float,
	ProjectHours float, 
	ProjectStatus varchar(1), 
	FltClientPO varchar(20),
	ContractType varchar(5)
)
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @serverName = (select @@servername)

select @dbName = null

select @dbName = case 	when @serverName = 'SQLDEV\SQLDEV' and @company = 'DENVER' then 'DEN_DEV_APP' 
						when @serverName = 'SQL1' and @company = 'DENVER' then 'DENVERAPP'
						when @serverName = 'SQLDEV\SQLDEV' and @company = 'SHOPPERNY' then 'SHOPPER_DEV_APP' 
						when @serverName = 'SQL1' and @company = 'SHOPPERNY' then 'SHOPPERAPP'
					end

set @sql1 = '

if object_id(''tempdb.dbo.##fjr'') > 0 drop table ##fjr
create table ##fjr
(
	Project	varchar(16) primary key clustered,
	OpenPO float,
	Actuals	float,
	BTD	float
)

if object_id(''tempdb.dbo.##fjrSums'') > 0 drop table ##fjrSums
create table ##fjrSums
(
	Project	char(16),
	SumType	varchar(14),
	SumValue float,
	primary key clustered (Project, SumType)
)

SET NOCOUNT ON

--FJR query.  To get down to one line for reporting pulling as main source
insert ##fjr
(
	Project,
	OpenPO,
	Actuals,
	BTD
)
select Project,
	OpenPO = coalesce((max(ExtCost) - max(CostVouched)),0), 
	--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
	Actuals = sum (CASE WHEN AcctGroupCode IN (''WA'',''WP'',''CM'',''FE'') then
						AmountBF + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15
						ELSE 0  
					END), 
	--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
	BTD = SUM (CASE WHEN ControlCode = ''BTD'' OR AcctGroupCode = ''PB'' THEN
					AmountBF + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15
					ELSE 0  
				END) 
from ' + @dbName + '.dbo.xvr_PA924_Main with (nolock)
where FSYearNum = ' + cast(@iYear as varchar) + '
group by Project


/*Using Current Locked Estimate view with functions.  Must roll up to project or cartestion joins */
insert ##fjrSums
(
	Project,
	SumType,
	SumValue
)
select CLE.Project,
	SumType = ''CLEFee'',
	SumValue = SUM(CASE WHEN (FC.code_group = ''FEE'' and FC.code_ID <> ''00975'') THEN CLE.CLEAmount ELSE 0 END)	
from ' + @dbName + '.dbo.xvr_Est_CLE CLE with (nolock)
inner join ' + @dbName + '.dbo.xIGFunctionCode FC with (nolock)
	on CLE.pjt_entity = FC.code_ID
group by CLE.Project

insert ##fjrSums
(
	Project,
	SumType,
	SumValue
)
select CLE.Project,
	SumType = ''CLEAmount'',
	SumValue = SUM(CLE.CLEAmount) 
from ' + @dbName + '.dbo.xvr_Est_CLE CLE 
inner join ' + @dbName + '.dbo.xIGFunctionCode FC with (nolock)
	on CLE.pjt_entity = FC.code_ID
group by CLE.Project

 -- Get the Travel Actuals
insert ##fjrSums
(
	Project,
	SumType,
	SumValue
)
select act.project,
	SumType = ''TRAVActuals'',
	SumValue = sum(act.Amount01 + act.Amount02 + act.Amount03 + act.Amount04 + act.Amount05 + act.Amount06 + act.Amount07 + act.Amount08 + act.Amount09 + act.Amount10 + act.Amount11 + act.Amount12 + act.Amount13 + act.Amount14 + act.Amount15)
FROM ' + @dbName + '.dbo.xvr_BU96C_Actuals act
inner join ' + @dbName + '.dbo.xIGFunctionCode fc with (nolock)
	on act.[function] = fc.code_id
	and fc.code_group = ''TRAV''
where act.acct = ''Billable''
group by act.project

-- Get the Out of Pocket Actuals
insert ##fjrSums
(
	Project,
	SumType,
	SumValue
)
SELECT act.project,
	SumType = ''OOPActuals'',
	SumValue = sum(act.Amount01 + act.Amount02 + act.Amount03 + act.Amount04 + act.Amount05 + act.Amount06 + act.Amount07 + act.Amount08 + act.Amount09 + act.Amount10 + act.Amount11 + act.Amount12 + act.Amount13 + act.Amount14 + act.Amount15)
FROM ' + @dbName + '.dbo.xvr_BU96C_Actuals act with (nolock)
inner join ' + @dbName + '.dbo.xIGFunctionCode fc with (nolock)
	on act.[function] = fc.code_id
where act.acct IN (''Billable'',''BILLABLE APS'',''BILLABLE FEES'') 
	and (coalesce(fc.code_group,'''') not in (''TRAV'',''FEE'') 
		or coalesce(fc.code_id,'''') = ''00975'')
group by act.project ' 


set @sql2 = '
--Per Email, include all WIP transactions.  Leaving in as easy to uncomment if decisions change.	   
insert ##fjrSums
(
	Project,
	SumType,
	SumValue
)
select d.Project,
	 SumType = ''WIPOvr60Amount'',
	 SumValue = SUM(CASE WHEN d.li_type NOT IN (''D'', ''A'') AND DateDiff(day, d.source_trx_date, GETDATE()) > 60 THEN d.amount
							ELSE 0
						END) 						
from ' + @dbName + '.dbo.PJINVDET d with (nolock)
left join ' + @dbName + '.dbo.PJINVHDR h with (nolock)
	ON d.draft_num = h.draft_num
inner join ' + @dbName + '.dbo.PJPROJ p with (nolock)
	ON d.project = p.project 
inner join ' + @dbName + '.dbo.PJACCT a with (nolock)
	ON d.acct = a.acct
left join ' + @dbName + '.dbo.xWIPAgingException ae with (nolock)
	on p.project = ae.JobId
where d.hold_status <> ''PG'' 
	and d.bill_status <> ''B''
	and a.acct_group_cd not in (''CM'', ''FE'')
	and (substring(d.acct, 1, 6) <> ''OFFSET'' 
		or d.acct = ''OFFSET PREBILL'')
	and ae.JobId is null
group By d.project		

insert ##fjrSums
(
	Project,
	SumType,
	SumValue
)
select project,
	SumType = ''TTLHrs'',
	SumValue = sum(units) 
from ' + @dbName + '.dbo.PJTRAN with (nolock)
where acct = ''LABOR''
group By Project 
		

select Company = ''' + @company + ''',
	Project = ltrim(rtrim(p.Project)), 
	[Status] = case when p.status_pa = ''I'' then ''INACTIVE'' else ''ACTIVE'' end,  
	project_billwith = ltrim(rtrim(b.project_billwith)),  
	ClientID = ltrim(rtrim(p.pm_id01)), 
	ClientName = coalesce(ltrim(rtrim(c.[name])),''Customer Name Unavailable''), 
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
	[Final On-Shelf Date] = case when x.pm_id28 = '''' then p.end_date else ltrim(rtrim(x.pm_id28)) end,
	CloseDate = ltrim(rtrim(p.pm_id08)), 
	OfferNum = ltrim(rtrim(p.pm_id32)), 
	ULEAmount = coalesce(ULE.ULEAmount, 0), 
	CLEAmount = coalesce(CleAmount.SumValue, 0), 
	CLEFeeAmount = coalesce(CleFee.SumValue, 0), 
	TRVActuals = coalesce(TRV.SumValue, 0), 
	OOPActuals = coalesce(OOP.SumValue, 0), 
	OpenPO = coalesce(FJR.OpenPO, 0), 
	Actuals = coalesce(FJR.Actuals, 0),  
	ActualsToBill = case when coalesce(fjr.Actuals,0) - coalesce(fjr.BTD,0) < 0 then 0 else coalesce(fjr.Actuals,0) - coalesce(fjr.BTD,0) end,
	BTD = coalesce(FJR.BTD, 0), 
	WIPOver60Amount = coalesce(RptWIP.SumValue, 0),  --Period Sensitive being removed
	ProjectHours = coalesce(ProjectHrs.SumValue, 0), 
	ProjectStatus = p.status_pa,
	-- Filtering fields required when adding logic for all parent child to return when either is pulled.
	--FltClientID = ip.pm_id01, 
	--FltProductCode = ip.pm_id02, 
	--FltProject = ip.project, 
	--FltProjectDesc = ip.project_desc, 
	--FltProjectStatus = ip.status_pa, 
	FltClientPO = p.purchase_order_num,
	--FltPM = ip.manager1, 
	--FltAcctSvc = ip.manager2,
	--FltOfferNum = ip.pm_id32, 
	--- ip.contract_type as FltContractType,
	ContractType = case when p.contract_type IN (''BPRD'',''FEE'',''MED'',''PARN'',''PDNT'',''PRNT'',''PROD'',''RET'',''NYK'') then ''PROD''
						when p.contract_type = ''TIME'' then ''TIME''
					  end '
					  
select @sql3 = '
from ' + @dbName + '.dbo.PJPROJ ip with (nolock)
INNER JOIN ' + @dbName + '.dbo.PJBILL A with (nolock)
	ON ip.Project = A.Project
INNER JOIN ' + @dbName + '.dbo.PJBILL B with (nolock)
	ON A.project_billwith = B.project_billwith 
INNER JOIN ' + @dbName + '.dbo.PJPROJ p with (nolock)
	ON b.project = p.project
LEFT OUTER JOIN ' + @dbName + '.dbo.xIGProdCode pc with (nolock)
	ON p.pm_id02 = pc.code_ID
LEFT OUTER JOIN ' + @dbName + '.dbo.CUSTOMER c with (nolock)
	ON p.pm_id01 = C.CustId
LEFT OUTER JOIN ' + @dbName + '.dbo.PJPROJEX x with (nolock)
	ON p.project = x.project
LEFT JOIN ' + @dbName + '.dbo.xClientContact xc with (nolock)
	ON p.user2 = xc.EA_ID
LEFT OUTER JOIN ##fjr FJR 
	ON p.project = FJR.Project
--Unlocked Estimate view by project
LEFT OUTER JOIN ' + @dbName + '.dbo.xvr_Est_ULE_Project ULE with (nolock)
	ON p.Project = ULE.Project
LEFT OUTER JOIN ##fjrSums CleFee
	ON p.Project = CleFee.Project
	and CleFee.SumType = ''CLEFee''		
LEFT OUTER JOIN ##fjrSums CleAmount 
	ON p.Project = CleAmount.Project
	and CleAmount.SumType = ''CLEAmount''
/*Using Travel with functions.  Must roll up to project or cartestion joins */
LEFT OUTER JOIN ##fjrSums trv
	ON p.Project = trv.Project
	and trv.SumType = ''TRAVActuals''
/*Using Out Of Pocket functions. This is all functions except TRAV and FEE Must roll up to project or cartestion joins */
LEFT OUTER JOIN ##fjrSums OOP
	ON p.Project = OOP.Project
	and OOP.SumType = ''OOPActuals'' 
/*Logic taken from BI902 and stripped down.  Including aging days for reuse*/	   
LEFT OUTER JOIN ##fjrSums RptWIP
	ON p.Project = RptWip.project
	and rptWip.SumType =  ''WIPOvr60Amount''
--Time query taken from Client P&L
LEFT OUTER JOIN ##fjrSums ProjectHrs 
	ON p.Project = ProjectHrs.project
	and ProjectHrs.SumType = ''TTLHrs''
--!!!!!! ALL FILTER CRITERIA MUST BE ON IP AND NOT P OR PARENT CHILD JOBS WILL NOT ALWAYS BE PULLED TOGETHER!!!!!!
where ip.contract_type IN (''BPRD'',''FEE'',''MED'',''PARN'',''PDNT'',''PRNT'',''PROD'',''RET'',''TIME'',''NYK'')
	and coalesce(b.project_billwith,'''') <> ''''
	and (ltrim(rtrim(ip.Project)) = ''' + @sProject + '''
		or ''' + @sProject + ''' = '''')
	and ltrim(rtrim(ip.pm_id01)) = ''' + @sClientId + '''
	and (ip.purchase_order_num = ''' + @sClientPO + '''
		or ''' + @sClientPO + ''' = '''')
	and ltrim(rtrim(ip.pm_id02)) = ''' + @sProductID + '''
	and ltrim(rtrim(ip.manager1)) = ''' + @sPM + '''
	and ip.status_pa = ''' + @sStatus + ''' 
order by ltrim(rtrim(p.manager1)), ltrim(rtrim(p.pm_id01)), ltrim(rtrim(p.pm_id02)), ltrim(rtrim(p.Project)), 
	case when p.contract_type IN (''BPRD'',''FEE'',''MED'',''PARN'',''PDNT'',''PRNT'',''PROD'',''RET'',''NYK'') then ''PROD''
		when p.contract_type = ''TIME'' then ''TIME''
	end 


drop table ##fjr
drop table ##fjrSums '

--print @sql3

select @sql = (@sql1 + @sql2 + @sql3)

insert ##fjrResults execute sp_executesql @sql

select Company = ltrim(rtrim(Company)),
	Project = ltrim(rtrim(Project)), 
	[Status] = ltrim(rtrim([Status])),  
	project_billwith = ltrim(rtrim(project_billwith)), 
	ClientID = ltrim(rtrim(ClientID)), 
	ClientName = ltrim(rtrim(ClientName)), 
	ProductID = ltrim(rtrim(ProductID)), 
	ProductDesc = ltrim(rtrim(ProductDesc)), 
	PM = ltrim(rtrim(PM)), 
	AcctService = ltrim(rtrim(AcctService)), 
	Project_Desc = ltrim(rtrim(Project_Desc)), 
	ClientContact = ltrim(rtrim(ClientContact)), 
	ContactEmailAddress = ltrim(rtrim(ContactEmailAddress)),
	ClientRefNo = ltrim(rtrim(ClientRefNo)),
	ECD, 
	OnShelfDate, 
	[Final On-Shelf Date],
	CloseDate, 
	OfferNum = ltrim(rtrim(OfferNum)), 
	ULEAmount, 
	CLEAmount, 
	CLEFeeAmount, 
	TRVActuals, 
	OOPActuals, 
	OpenPO,  
	Actuals,   
	ActualsToBill, 
	BTD, 
	WIPOver60Amount,
	ProjectHours, 
	ProjectStatus = ltrim(rtrim(ProjectStatus)), 
	FltClientPO = ltrim(rtrim(FltClientPO)),
	ContractType = ltrim(rtrim(ContractType))
from ##fjrResults

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on AcctLeadershipFjrRpt to BFGROUP
go

grant execute on AcctLeadershipFjrRpt to MSDSL
go

grant control on AcctLeadershipFjrRpt to MSDSL
go

grant execute on AcctLeadershipFjrRpt to MSDynamicsSL
go