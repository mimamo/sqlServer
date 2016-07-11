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
	
		execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sClientId = '1LFSU|1JJVC', @sProductId = 'TRDE|CUST', @sPM = 'SAPPEL|CUST', @sStatus = 'A'
		execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sClientId = '1LFSU', @sProductId = 'TRDE', @sPM = 'SAPPEL', @sStatus = 'A'
		
		execute DENVERAPP.dbo.AcctLeadershipFjrRpt @company = 'DENVER|SHOPPERNY', @sClientId = '1ARCAS|1GILNA|1PGHBA', @sProductId = 'CLA', @sPM = 'CLOOMIS', @sStatus = 'A'
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
DECLARE @CurrentDate Date	--Would have been used in WIP AGING logic
DECLARE @iYear as int

SET @CurrentDate = getdate()
SET @iYear = year(@CurrentDate)

declare @sql nvarchar(max)
declare @sql1 nvarchar(max)
declare @sql2 nvarchar(max)
declare @sql3 nvarchar(max)
declare @sql4 nvarchar(max)
declare @sql5 nvarchar(max)
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
	Disposition varchar(12),
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
	declare @minParent varchar(16)
	
	declare @ParsedClientID table (clientId varchar(255) primary key clustered)
	declare @ParsedProductID table (productId varchar(255) primary key clustered)
	declare @ParsedStatus table (status varchar(255) primary key clustered)
	declare @ParsedPM table (PM varchar(255) primary key clustered)

	if object_id(''tempdb.dbo.##uni123'') > 0 drop table ##uni123
	create table ##uni123
	(
		Project	varchar(16),
		ClientID varchar(30), 
		ProductID varchar(30), 	
		PM varchar(10),
		ParentPM varchar(10),
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
		primary key clustered (Project, project_billwith, rowId)
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
	
	if object_id(''tempdb.dbo.##pos'') > 0 drop table ##pos
	create table ##pos
	(
		Project varchar(16),
		ExtCost	float,
		CostVouched float,
		primary key clustered (Project)
	)
	
	if object_id(''tempdb.dbo.##actuals'') > 0 drop table ##actuals
	create table ##actuals
	(
		project	varchar(16),
		acct varchar(16),
		amountSum float,
		fsyear_num varchar(4),
		acct_group_cd varchar(2),
		control_code varchar(30),
		rowId int identity(1,1),
		primary key clustered (acct, project, rowId) 
	) 
	
	if object_id(''tempdb.dbo.##standAlone'') > 0 drop table ##standAlone
	create table ##standAlone
	(
		project varchar(16) primary key clustered
	)	'

set @sql2 = '	
	SET NOCOUNT ON

	insert @ParsedClientID (clientId)
	SELECT Name
	FROM DENVERAPP.dbo.SplitString(''' + @sClientId + ''')

	insert @ParsedProductID (productId)
	SELECT Name
	FROM DENVERAPP.dbo.SplitString(''' + @sProductId + ''')
	
	insert @ParsedPM (PM)
	SELECT Name
	FROM DENVERAPP.dbo.SplitString(''' + @sPM + ''')

	insert ##uni123
	(
		Project, 
		clientID,
		ProductID,
		PM,
		ParentPM,
		[Status],
		AcctService,
		Project_Desc,
		ClientRefNo,
		OnShelfDate,
		CloseDate,
		OfferNum,
		ProjectStatus,
		FltClientPO,
		ContractType,
		user2,
		project_billwith,
		[Final On-Shelf Date],
		ClientName,
		ProductDesc,
		ClientContact,
		ContactEmailAddress,
		ECD,
		RowId
	)	
	select Project = ltrim(rtrim(ip.Project)), 
		clientID = ltrim(rtrim(ip.pm_id01)), 
		ProductID = ltrim(rtrim(ip.pm_id02)), 
		PM = ltrim(rtrim(ip.manager1)), 
		ParentPM = ltrim(rtrim(p.manager1)), 
		[Status] = case when ip.status_pa = ''I'' then ''INACTIVE'' else ''ACTIVE'' end,	
		AcctService = ltrim(rtrim(ip.manager2)), 
		Project_Desc = ltrim(rtrim(ip.Project_Desc)),
		ClientRefNo = ltrim(rtrim(ip.purchase_order_num)),
		OnShelfDate = ltrim(rtrim(ip.end_date)), 
		CloseDate = ltrim(rtrim(ip.pm_id08)), 
		OfferNum = ltrim(rtrim(ip.pm_id32)),  
		ProjectStatus = ip.status_pa,
		FltClientPO = ip.purchase_order_num,
		ContractType = case when ip.contract_type IN (''BPRD'',''FEE'',''MED'',''PARN'',''PDNT'',''PRNT'',''PROD'',''RET'',''NYK'') then ''PROD''
							when ip.contract_type = ''TIME'' then ''TIME''
							 end,	
		user2 = ip.user2,
		project_billwith = ltrim(rtrim(a.project_billwith)),  		
		[Final On-Shelf Date] = case when x.pm_id28 = '''' then ip.end_date else ltrim(rtrim(x.pm_id28)) end,				
		ClientName = coalesce(ltrim(rtrim(c.[name])),''Customer Name Unavailable''), 
		ProductDesc = ltrim(rtrim(pc.descr)), 
		ClientContact = ltrim(rtrim(xc.CName)), 
		ContactEmailAddress = ltrim(rtrim(xc.EmailAddress)),
		ECD = ltrim(rtrim(x.pm_id28)),
		RowId = row_number() over (partition by 1 order by a.project_billwith) 		
	from ' + @dbName + '.dbo.PJBILL A with (nolock) 
	inner join ' + @dbName + '.dbo.PJPROJ p with (nolock)  -- parent  
		on a.project_billwith = case when a.project_billwith <> '''' then p.Project else a.project_billwith end
	inner join ' + @dbName + '.dbo.PJPROJ ip with (nolock)  -- child
		ON a.project = ip.project 		
	inner join @parsedClientId pcl 
		on ltrim(rtrim(ip.pm_id01)) = ltrim(rtrim(pcl.clientId))  
	inner join @ParsedProductID ppi
		on ltrim(rtrim(ip.pm_id02)) = ppi.ProductId 
	inner join @ParsedPM ppm
		on ltrim(rtrim(p.manager1)) = ppm.PM
	left join ' + @dbName + '.dbo.xIGProdCode pc with (nolock)
		ON ip.pm_id02 = pc.code_ID
	left join ' + @dbName + '.dbo.CUSTOMER c with (nolock)
		ON ip.pm_id01 = C.CustId
	left join ' + @dbName + '.dbo.PJPROJEX x with (nolock)
		ON ip.project = x.project
	left join ' + @dbName + '.dbo.xClientContact xc with (nolock)
		ON ip.user2 = xc.EA_ID 
	--!!!!!! ALL FILTER CRITERIA MUST BE ON IP AND NOT P OR PARENT CHILD JOBS WILL NOT ALWAYS BE PULLED TOGETHER!!!!!!
	where ip.contract_type IN (''BPRD'',''FEE'',''MED'',''PARN'',''PDNT'',''PRNT'',''PROD'',''RET'',''TIME'',''NYK'')	
		and coalesce(ltrim(rtrim(a.project_billwith)),'''') = case when ''' + @sProject + ''' = '''' then coalesce(ltrim(rtrim(a.project_billwith)),'''') else ''' + @sProject + ''' end
		and coalesce(ltrim(rtrim(ip.purchase_order_num)),'''') = case when ''' + @sClientPO + ''' = '''' then coalesce(ltrim(rtrim(ip.purchase_order_num)),'''') else ''' + @sClientPO + ''' end
		and ip.status_pa in(''A'',''I'')
		and a.project_billwith <> '''' '
						
-- when parent job is active, select active and inactive children
select @sql3 = '
	if ''' + @sStatus + ''' = ''A''
	begin
	
		select @minParent = null	
		select @minParent = min(Project)
		from ##uni123
		where Project = project_billwith
			and ProjectStatus <> ''A''
		
		while @minParent is not null
		begin	
			delete from ##uni123
			where project_billwith = @minParent
				and project <> project_billwith
		
			select @minParent = min(Project)
			from ##uni123
			where Project = project_billwith
				and ProjectStatus <> ''A''
				and project > @minParent	
		end

	end 
	
	insert ##actuals
	(
		project, 
		acct,
		amountSum, 
		fsyear_num, 
		acct_group_cd, 
		control_code
	)
	SELECT act.project, 
		act.acct,
		amountSum = act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 +	act.amount_07 + act.amount_08
					+ act.amount_09 + act.amount_10 + act.amount_11 + act.amount_12 + act.amount_13 + act.amount_14 + act.amount_15 + act.amount_bf, 
		act.fsyear_num, 
		coalesce(a.acct_group_cd, ''''),
		coalesce(c.control_code, '''')
	FROM ##uni123 u
	inner join ' + @dbName + '.dbo.PJACTROL act with (nolock)
		on u.project = act.project
	LEFT JOIN ' + @dbName + '.dbo.PJACCT a with (nolock)
		ON act.acct = a.acct 
	LEFT JOIN ' + @dbName + '.dbo.PJCONTRL c with (nolock)
		ON act.acct = c.control_data
	WHERE a.acct_group_cd IN (''WA'', ''WP'', ''CM'', ''PB'', ''FE'') 
		OR c.control_code = ''BTD''
	
	insert ##pos
	(
		Project,
		ExtCost,
		CostVouched	
	)
	SELECT p.ProjectID,
		sum(p.CuryExtCost),
		sum(p.CuryCostVouched)
	from ##uni123 u
	inner join ' + @dbName + '.dbo.PurOrdDet p with (nolock)
		on u.Project = p.projectId
	inner join ' + @dbName + '.dbo.PurchOrd po with (nolock)
		on p.PONbr = po.PONbr
	WHERE po.status in (''O'', ''P'')
	GROUP BY p.ProjectID 
	
	
	--FJR query.  To get down to one line for reporting pulling as main source
	insert ##fjr
	(
		Project,
		OpenPO,
		Actuals,
		BTD
	)
	select u.Project,
		OpenPO = coalesce((max(po.ExtCost) - max(po.CostVouched)),0), 
		--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
		Actuals = sum (CASE WHEN act.acct_group_cd IN (''WA'',''WP'',''CM'',''FE'') then act.AmountSum
							ELSE 0  
						END), 
		--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
		BTD = SUM (CASE WHEN act.control_code = ''BTD'' OR act.acct_group_cd = ''PB'' then act.AmountSum
						ELSE 0  
					END) 
	from ##uni123 u
	LEFT JOIN ##actuals act 
		on u.project = act.project
	LEFT JOIN ##pos po 
		on u.project = po.Project
	where act.fsyear_num = ' + cast(@iYear as varchar) + ' 
	group by u.Project '

/*Using Current Locked Estimate view with functions.  Must roll up to project or cartestion joins */
select @sql4 = '
	insert ##fjrSums
	(
		Project,
		SumType,
		SumValue
	)
	select CLE.Project,
		SumType = ''CLEFee'',
		SumValue = SUM(CASE WHEN (FC.code_group = ''FEE'' and FC.code_ID <> ''00975'') THEN CLE.Amount ELSE 0 END)	
	from ' + @dbName + '.dbo.PJREVCAT CLE with (nolock)
	inner join ' + @dbName + '.dbo.PJPROJEX ex 
		ON cle.Project = ex.Project 
		and cle.RevID = ex.pm_id25
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
		SumValue = SUM(CLE.Amount) 
	from ' + @dbName + '.dbo.PJREVCAT CLE with (nolock)
	inner join ' + @dbName + '.dbo.PJPROJEX ex 
		ON cle.Project = ex.Project 
		and cle.RevID = ex.pm_id25
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
	SELECT act.project, 

		SumType = ''OOPActuals'',
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
							END) '						

 select @sql5 = '
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
	
	insert ##standAlone (project)
	select project_billwith 
	from ##uni123
	group by project_billwith
	having count(1) = 1

	select distinct Company = ''' + @pcompany + ''',
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
		Disposition = case when sa.project is not null then ''Stand-alone''
							when u.project_billwith <> '''' and u.project_billwith = u.Project then ''Parent''
							else ''Child''
						end,
		u.RowId 
	from ##uni123 u
	INNER JOIN ' + @dbName + '.dbo.PJTran T 
		ON u.Project = T.project
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
	/*Logic taken from BI902 and stripped down.  Including aging days for reuse*/	
	LEFT OUTER JOIN ##fjrSums OOP
		ON u.Project = OOP.Project
		and OOP.SumType = ''OOPActuals''      
	LEFT OUTER JOIN ##fjrSums RptWIP
		ON u.Project = RptWip.project
		and rptWip.SumType =  ''WIPOvr60Amount''
	--Time query taken from Client P&L
	LEFT OUTER JOIN ##fjrSums ProjectHrs 
		ON u.Project = ProjectHrs.project
		and ProjectHrs.SumType = ''TTLHrs'' 
	left join ##standAlone sa
		on u.project = sa.project
	
	drop table ##fjr
	drop table ##fjrSums 
	drop table ##uni123  
	drop table ##standAlone '


	print @sql3
	
	select @sql = (@sql1 + @sql2 + @sql3 + @sql4 + @sql5)

	insert ##fjrResults 
	execute sp_executesql @sql
	
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
		Disposition,
		RowId
	from ##fjrResults
	order by  ltrim(rtrim(Company)), ltrim(rtrim(ClientID)), ltrim(rtrim(project_billwith)), ltrim(rtrim(Project))



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