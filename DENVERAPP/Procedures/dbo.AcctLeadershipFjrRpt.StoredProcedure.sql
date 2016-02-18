USE DENVERAPP
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
	@company varchar(50),
	@sProject varchar(16) = null,
	@sClientID varchar(max),
	@sClientPO varchar(20)= null,
	@sProductID varchar(max),
	@sPM varchar(max),
	@sStatus varchar(5)
	
 AS


/*******************************************************************************************************
*   DENVERAPP.dbo.AcctLeadershipFjrRpt 
*
*   Creator:   
*   Date:          
*   
*
*   Notes:         select distinct manager1 from SHOPPERAPP.dbo.PJPROJ 
					where contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','TIME') 
			
                  
*
*   Usage:	set statistics io on
	
		execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sClientId = '1LFSU|1JJVC', @sProductId = 'TRDE|JJHW', @sPM = 'SAPPEL|MMULDOON', @sStatus = 'A|I'
		execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sClientId = '1LFSU', @sProductId = 'TRDE', @sPM = 'SAPPEL', @sStatus = 'A'
		
		execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'DENVER|SHOPPERNY', @sClientId = '1JJVC|1IZZE', @sProductId = 'CUST|IZZE', @sPM = 'CUST|ALUU', @sStatus = 'A'
		execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'DENVER', @sClientId = '1IZZE', @sProductId = 'IZZE', @sPM = 'ALUU', @sStatus = 'A'
		

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
SET @iYear = year(@CurrentDate)

declare @sql nvarchar(max)
declare @sql1 nvarchar(max)
declare @sql2 nvarchar(max)
declare @sql3 nvarchar(max)
declare @sql4 nvarchar(max)
declare @serverName varchar(13)
declare @dbName nvarchar(24)

---------------------------------------------
-- create temp tables
---------------------------------------------
declare @ParsedCompany table (company varchar(50))

if object_id('tempdb.dbo.##fjrResults') > 0 drop table ##fjrResults
create table ##fjrResults
(
	Company varchar(50),
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
	ContractType varchar(5),
	ParentFlag int,
	rowId int,
	constraint pkc_##fjrResults primary key (ClientId, ProductId, PM, [Status], Project, rowId)
)

create nonclustered index ix_##fjrResults on ##fjrResults (project_billwith, Project)


---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @sProject = coalesce(@sProject, '')
select @sClientPO = coalesce(@sClientPO, '')

insert @ParsedCompany (company)
select Name
from DENVERAPP.dbo.SplitString(@company)

declare @pcompany varchar(50)
	
select @pcompany = min(company) 
from @ParsedCompany

while @pcompany is not null
begin
	
	select @serverName =  @@servername

	select @dbName = null

	select @dbName = case 	when @serverName = 'SQLDEV\SQLDEV' and @pcompany = 'DENVER' then 'DENVERAPP' 
							when @serverName = 'SQL1' and @pcompany = 'DENVER' then 'DENVERAPP'
							when @serverName = 'SQLDEV\SQLDEV' and @pcompany = 'SHOPPERNY' then 'SHOPPER_DEV_APP' 
							when @serverName = 'SQL1' and @pcompany = 'SHOPPERNY' then 'SHOPPERAPP'
						end

	set @sql1 = '

	if object_id(''tempdb.dbo.##uni123'') > 0 drop table ##uni123
	create table ##uni123
	(
		Project	varchar(16),
		ClientID varchar(30), 
		ProductID varchar(30), 	
		PM varchar(10),
		[Status] varchar(10),
		AcctService varchar(10),
		Project_Desc varchar(60), 
		ClientRefNo varchar(20),
		OnShelfDate datetime, 
		[Final On-Shelf Date] datetime, 
		CloseDate datetime, 
		OfferNum varchar(30),
		ProjectStatus varchar(1),
		FltClientPO varchar(20),
		ContractType varchar(5),
		user2 varchar(30),
		project_billwith varchar(16),  
		ClientName varchar(60),
		ProductDesc varchar(30),  
		ClientContact varchar(30),
		ContactEmailAddress varchar(50),
		ECD datetime,  
		rowId int,
		primary key clustered (Project, rowId)
	)


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
		Project	varchar(16),
		SumType	varchar(14),
		SumValue float,
		primary key clustered (Project, SumType)
	)

	SET NOCOUNT ON


	declare @ParsedClientID table (clientId varchar(255))
	declare @ParsedProductID table (productId varchar(255))
	declare @ParsedPM table (PM varchar(255))
	declare @ParsedStatus table ([status] varchar(255))


	insert @ParsedClientID (clientId)
	SELECT Name
	FROM DENVERAPP.dbo.SplitString(''' + @sClientId + ''')

	insert @ParsedProductID (productId)
	SELECT Name
	FROM DENVERAPP.dbo.SplitString(''' + @sProductId + ''')

	insert @ParsedPM (PM)
	SELECT Name
	FROM DENVERAPP.dbo.SplitString(''' + @sPM + ''')

	insert @ParsedStatus ([status])
	SELECT Name
	FROM DENVERAPP.dbo.SplitString(''' + @sStatus + ''')

	insert ##uni123
	(
		Project,
		ClientID, 
		ProductID, 	
		PM,
		[Status],
		AcctService,
		Project_Desc, 
		ClientRefNo,
		OnShelfDate, 
		[Final On-Shelf Date], 
		CloseDate, 
		OfferNum,
		ProjectStatus,
		FltClientPO,
		ContractType,
		user2,
		project_billwith,  
		ClientName,
		ProductDesc,  
		ClientContact,
		ContactEmailAddress,
		ECD,
		RowId
	)
	select Project = ltrim(rtrim(ip.Project)), 
		ClientID = ltrim(rtrim(ip.pm_id01)), 
		ProductID = ltrim(rtrim(ip.pm_id02)), 
		PM = ltrim(rtrim(ip.manager1)), 	
		[Status] = case when ip.status_pa = ''I'' then ''INACTIVE'' else ''ACTIVE'' end,
		AcctService = ltrim(rtrim(ip.manager2)), 
		Project_Desc = ltrim(rtrim(ip.Project_Desc)),
		ClientRefNo = ltrim(rtrim(ip.purchase_order_num)),
		OnShelfDate = ltrim(rtrim(ip.end_date)), 
		[Final On-Shelf Date] = case when x.pm_id28 = '''' then ip.end_date else ltrim(rtrim(x.pm_id28)) end,	
		CloseDate = ltrim(rtrim(ip.pm_id08)), 
		OfferNum = ltrim(rtrim(ip.pm_id32)),  
		ProjectStatus = ip.status_pa,
		FltClientPO = ip.purchase_order_num,
		ContractType = case when ip.contract_type IN (''BPRD'',''FEE'',''MED'',''PARN'',''PDNT'',''PRNT'',''PROD'',''RET'',''NYK'') then ''PROD''
							when ip.contract_type = ''TIME'' then ''TIME''
						  end,	
		ip.user2,
		project_billwith = ltrim(rtrim(a.project_billwith)),  
		ClientName = coalesce(ltrim(rtrim(c.[name])),''Customer Name Unavailable''), 
		ProductDesc = ltrim(rtrim(pc.descr)), 
		ClientContact = ltrim(rtrim(xc.CName)), 
		ContactEmailAddress = ltrim(rtrim(xc.EmailAddress)),
		ECD = ltrim(rtrim(x.pm_id28)),
		RowId = row_number() over (partition by 1 order by a.project_billwith) 
	from ' + @dbName + '.dbo.PJBILL A with (nolock) 
	INNER JOIN ' + @dbName + '.dbo.PJPROJ p with (nolock)  -- parent  
		ON A.project_billwith = case when A.project_billwith <> '''' then p.Project else A.project_billwith end
	INNER JOIN ' + @dbName + '.dbo.PJPROJ ip with (nolock)  -- child
		ON a.project = ip.project 
	inner join @parsedClientId pcl 
		on ltrim(rtrim(pcl.clientId)) = ltrim(rtrim(ip.pm_id01))
	inner join @ParsedProductID ppi
		on ppi.ProductId = ltrim(rtrim(ip.pm_id02)) '

	set @sql2 = '
	inner join @ParsedPM ppm
		on ppm.PM = ltrim(rtrim(ip.manager1)) 
	inner join @ParsedStatus ps
		on ps.[status] = ip.status_pa 
	LEFT OUTER JOIN ' + @dbName + '.dbo.xIGProdCode pc with (nolock)
		ON ip.pm_id02 = pc.code_ID
	LEFT OUTER JOIN ' + @dbName + '.dbo.CUSTOMER c with (nolock)
		ON ip.pm_id01 = C.CustId
	LEFT OUTER JOIN ' + @dbName + '.dbo.PJPROJEX x with (nolock)
		ON ip.project = x.project
	LEFT JOIN ' + @dbName + '.dbo.xClientContact xc with (nolock)
		ON ip.user2 = xc.EA_ID 
	--!!!!!! ALL FILTER CRITERIA MUST BE ON IP AND NOT P OR PARENT CHILD JOBS WILL NOT ALWAYS BE PULLED TOGETHER!!!!!!
	where ip.contract_type IN (''BPRD'',''FEE'',''MED'',''PARN'',''PDNT'',''PRNT'',''PROD'',''RET'',''TIME'',''NYK'')
		and (ltrim(rtrim(ip.Project)) = ''' + @sProject + '''
			or ''' + @sProject + ''' = '''')
		and (ip.purchase_order_num = ''' + @sClientPO + '''
			or ''' + @sClientPO + ''' = '''')

	--FJR query.  To get down to one line for reporting pulling as main source
	insert ##fjr
	(
		Project,
		OpenPO,
		Actuals,
		BTD
	)
	select m.Project,
		OpenPO = coalesce((max(m.ExtCost) - max(m.CostVouched)),0), 
		--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
		Actuals = sum (CASE WHEN m.AcctGroupCode IN (''WA'',''WP'',''CM'',''FE'') then
							m.AmountBF + m.Amount01 + m.Amount02 + m.Amount03 + m.Amount04 + m.Amount05 + m.Amount06 + m.Amount07 + m.Amount08 + m.Amount09 + m.Amount10 + m.Amount11 + m.Amount12 + m.Amount13 + m.Amount14 + m.Amount15
							ELSE 0  
						END), 
		--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
		BTD = SUM (CASE WHEN m.ControlCode = ''BTD'' OR AcctGroupCode = ''PB'' THEN
						m.AmountBF + m.Amount01 + m.Amount02 + m.Amount03 + m.Amount04 + m.Amount05 + m.Amount06 + m.Amount07 + m.Amount08 + m.Amount09 + m.Amount10 + m.Amount11 + m.Amount12 + m.Amount13 + m.Amount14 + m.Amount15
						ELSE 0  
					END) 
	from ' + @dbName + '.dbo.xvr_PA924_Main m with (nolock)
	inner join ##uni123 u
		on m.project = u.project
	where m.FSYearNum = ' + cast(@iYear as varchar) + '
	group by m.Project   


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
	inner join ##uni123 u
		on cle.project = u.project
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
	inner join ##uni123 u
		on act.project = u.project
	where act.acct = ''Billable''
	group by act.project

	-- Get the Out of Pocket Actuals
	insert ##fjrSums
	(
		Project,
		SumType,
		SumValue
	)
	SELECT act.project, '

	select @sql3 = '	SumType = ''OOPActuals'',
		SumValue = sum(act.Amount01 + act.Amount02 + act.Amount03 + act.Amount04 + act.Amount05 + act.Amount06 + act.Amount07 + act.Amount08 + act.Amount09 + act.Amount10 + act.Amount11 + act.Amount12 + act.Amount13 + act.Amount14 + act.Amount15)
	FROM ' + @dbName + '.dbo.xvr_BU96C_Actuals act with (nolock) 


	inner join ' + @dbName + '.dbo.xIGFunctionCode fc with (nolock)
		on act.[function] = fc.code_id
	inner join ##uni123 u
		on act.project = u.project
	where act.acct IN (''Billable'',''BILLABLE APS'',''BILLABLE FEES'') 
		and (coalesce(fc.code_group,'''') not in (''TRAV'',''FEE'') 
			or coalesce(fc.code_id,'''') = ''00975'')
	group by act.project  


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
	from ##uni123 u
	inner join ' + @dbName + '.dbo.PJINVDET d with (nolock)
		on u.project = d.project
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
	select t.project,
		SumType = ''TTLHrs'',
		SumValue = sum(t.units) 
	from ' + @dbName + '.dbo.PJTRAN t with (nolock)
	inner join ##uni123 u
		on t.project = u.project
	where t.acct = ''LABOR''
	group By t.Project 
			
	select Company = ''' + @pcompany + ''',
		u.Project, 
		u.[Status],  
		u.project_billwith,  
		u.ClientID, 
		u.ClientName, 
		u.ProductID, 
		u.ProductDesc, 
		u.PM, 
		u.AcctService, 
		u.Project_Desc, 
		u.ClientContact, 
		u.ContactEmailAddress,
		u.ClientRefNo,
		u.ECD, 
		u.OnShelfDate, 
		u.[Final On-Shelf Date],
		u.CloseDate, 
		u.OfferNum, 
		ULEAmount = coalesce(ULE.UleAmount, 0), 
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
		u.ProjectStatus,
		u.FltClientPO,
		u.ContractType,
		ParentFlag = case when u.project_billwith <> '''' and u.project_billwith = u.Project then 1 else 0 end,
		u.RowId
	from ##uni123 u
	--Unlocked Estimate view by project
	LEFT OUTER JOIN ' + @dbName + '.dbo.xvr_Est_ULE_Project ULE with (nolock)
		ON u.Project = ULE.Project
	LEFT OUTER JOIN ##fjr FJR 
		ON u.project = FJR.Project
	LEFT OUTER JOIN ##fjrSums CleFee
		ON u.Project = CleFee.Project
		and CleFee.SumType = ''CLEFee''		
	LEFT OUTER JOIN ##fjrSums CleAmount 
		ON u.Project = CleAmount.Project
		and CleAmount.SumType = ''CLEAmount''
	/*Using Travel with functions.  Must roll up to project or cartestion joins */
	LEFT OUTER JOIN ##fjrSums trv
		ON u.Project = trv.Project
		and trv.SumType = ''TRAVActuals''
	/*Using Out Of Pocket functions. This is all functions except TRAV and FEE Must roll up to project or cartestion joins */
	LEFT OUTER JOIN ##fjrSums OOP
		ON u.Project = OOP.Project
		and OOP.SumType = ''OOPActuals''  '

	select @sql4 = '/*Logic taken from BI902 and stripped down.  Including aging days for reuse*/	    
	LEFT OUTER JOIN ##fjrSums RptWIP
		ON u.Project = RptWip.project
		and rptWip.SumType =  ''WIPOvr60Amount''
	--Time query taken from Client P&L
	LEFT OUTER JOIN ##fjrSums ProjectHrs 
		ON u.Project = ProjectHrs.project
		and ProjectHrs.SumType = ''TTLHrs''

	drop table ##fjr
	drop table ##fjrSums 
	drop table ##uni123 '

	print @sql1

	select @sql = (@sql1 + @sql2 + @sql3 + @sql4)

	insert ##fjrResults execute sp_executesql @sql
	
	select @pcompany = min(company) 
	from @ParsedCompany
	where company > @pcompany

end


	--execute sp_executesql @sql

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
		ContractType = ltrim(rtrim(ContractType)),
		ParentFlag,
		RowId
	from ##fjrResults
	order by rowId



/*

execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sClientId = '1LFSU', @sProductId = 'TRDE', @sPM = 'SAPPEL', @sStatus = 'A'

execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sClientId = '1LFSU|1JJVC', @sProductId = 'TRDE|JJHW', @sPM = 'SAPPEL|MMULDOON', @sStatus = 'A|I'
*/



--drop table ##fjrResults
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