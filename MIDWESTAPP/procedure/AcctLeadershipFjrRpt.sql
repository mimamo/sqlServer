USE midwestapp
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
	@sClientID varchar(max),
	@sProject varchar(16) = null,	
	@sClientPO varchar(20)= null,
	@sProductID varchar(max),
	@sPM varchar(max),
	@sType varchar(max),
	@sStatus varchar(5)
	
 AS


/*******************************************************************************************************
*   midwestapp.dbo.AcctLeadershipFjrRpt 
*
*   Creator:   
*   Date:          
*   
*
*   Notes:         select distinct manager1 from midwestapp.dbo.PJPROJ 
				   where contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','TIME') 
				   
				   
				   select distinct customer from midwestapp.dbo.PJPROJ 
				   where contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','TIME') 
				   
				   select distinct manager1 from midwestapp.dbo.PJPROJ 
				   where customer in('1ALLST','1ALLIN')
					and pm_id02 in('0001','0275')
					and status_pa = 'A'
					and contract_type in('1OTP','1OTR','SEA')
								   
				   select distinct customer 
				   from midwestapp.dbo.PJPROJ 
				   where customer in('1ALLST','1ALLIN')
					and pm_id02 in('0001','0275')
					and manager1 in('KOLSON')--,'ADOWNING')
					and status_pa = 'A'
					and contract_type in('1OTP','1OTR','SEA')
                  
                  select distinct Type = contract_type 
                  from PJPROJ
                  where customer in('1HON')
                  and pm_id02 in('0223')
                  and manager1 = 'ABYERS'
                  and status_pa = 'A'
                  
                  select *
                  from midwestapp.dbo.pjproj
                  where project = '00839616AGY'
                  
                  select *
                  from midwestapp.dbo.pjbill
                  where project = '00839616AGY'
                  
					select *
                  from midwestapp.dbo.pjbill
                  where project_billwith = '00839616AGY'
*
*   Usage:	set statistics io on
	
		execute midwestapp.dbo.AcctLeadershipFjrRpt @sClientId = '1ALLIN|1ALLST', @sProductId = '0275|0001', @sPM = 'KOLSON', @sType = '1OTP|1OTR|SEA', @sStatus = 'A'
		execute midwestapp.dbo.AcctLeadershipFjrRpt @sClientId = '1HON', @sProductId = '0223', @sPM = 'ABYERS', @sType = '1PRJ', @sStatus = 'A'
		
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/26/2016	Put query from SSRS into procedure
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
-- For internal reporting use
declare @CurrentDate Date	--Would have been used in used in WIP AGING logic
declare @iYear as int

SET @CurrentDate = getdate()
SET @iYear = year(@CurrentDate)

---------------------------------------------
-- create temp tables
---------------------------------------------
declare @MidParsedClientID table (clientId varchar(255))
declare @MidParsedProductID table (productId varchar(255))
declare @MidParsedPM table (PM varchar(255))
declare @MidParsedType table ([type] varchar(255))
declare @MidParsedStatus table ([status] varchar(255))


if object_id('tempdb.dbo.##MidUni123') > 0 drop table ##MidUni123
create table ##MidUni123
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

create nonclustered index ix_##MidUni123 on ##MidUni123 (project_billwith, Project)

if object_id('tempdb.dbo.##Midfjr') > 0 drop table ##Midfjr
create table ##Midfjr
(
	Project	varchar(16) primary key clustered,
	OpenPO float,
	Actuals	float,
	BTD	float
)

if object_id('tempdb.dbo.##MidfjrSums') > 0 drop table ##MidfjrSums
create table ##MidfjrSums
(
	Project	varchar(16),
	SumType	varchar(14),
	SumValue float,
	primary key clustered (Project, SumType)
)
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


insert @MidParsedClientID (clientId)
select Name
from denverapp.dbo.SplitString(@sClientId)

insert @MidParsedProductID (productId)
select Name
from denverapp.dbo.SplitString(@sProductId)

insert @MidParsedPM (PM)
select Name
from denverapp.dbo.SplitString(@sPM)

insert @MidParsedType ([type])
select Name
from denverapp.dbo.SplitString(@sType)

insert @MidParsedStatus ([status])
select Name
from denverapp.dbo.SplitString(@sStatus)


insert ##MidUni123
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
	[Status] = case when ip.status_pa = 'I' then 'INACTIVE' else 'ACTIVE' end,
	AcctService = ltrim(rtrim(ip.manager2)), 
	Project_Desc = ltrim(rtrim(ip.Project_Desc)),
	ClientRefNo = ltrim(rtrim(ip.purchase_order_num)),
	OnShelfDate = ltrim(rtrim(ip.end_date)), 
	[Final On-Shelf Date] = case when x.pm_id28 = '' then ip.end_date else ltrim(rtrim(x.pm_id28)) end,	
	CloseDate = ltrim(rtrim(ip.pm_id08)), 
	OfferNum = ltrim(rtrim(ip.pm_id32)),  
	ProjectStatus = ip.status_pa,
	FltClientPO = ip.purchase_order_num,
	ContractType = case when ip.contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','NYK') then 'PROD'
						else ip.contract_type 
					  end,	
	ip.user2,
	project_billwith = ltrim(rtrim(a.project_billwith)),  
	ClientName = coalesce(ltrim(rtrim(c.[name])),'Customer Name Unavailable'), 
	ProductDesc = ltrim(rtrim(pc.descr)), 
	ClientContact = ltrim(rtrim(xc.CName)), 
	ContactEmailAddress = ltrim(rtrim(xc.EmailAddress)),
	ECD = ltrim(rtrim(x.pm_id28)),
	RowId = row_number() over (partition by 1 order by a.project_billwith) 
from midwestapp.dbo.PJBILL A with (nolock) 
inner join midwestapp.dbo.PJPROJ p with (nolock)  -- parent  
	on A.project_billwith = case when A.project_billwith <> '' then p.Project else A.project_billwith end
inner join midwestapp.dbo.PJPROJ ip with (nolock)  -- child
	on a.project = ip.project 
inner join @MidParsedClientID pcl 
	on ltrim(rtrim(pcl.clientId)) = ltrim(rtrim(ip.pm_id01))
inner join @MidParsedProductID ppi
	on ppi.ProductId = ltrim(rtrim(ip.pm_id02)) 
inner join @MidParsedPM ppm
	on ppm.PM = ltrim(rtrim(ip.manager1)) 
inner join @MidParsedStatus ps
	on ps.[status] = ip.status_pa 
inner join @MidParsedType pt
	on pt.[type] = ip.contract_type
left outer join midwestapp.dbo.xIGProdCode pc with (nolock)
	on ip.pm_id02 = pc.code_ID
left outer join midwestapp.dbo.CUSTOMER c with (nolock)
	on ip.pm_id01 = C.CustId
left outer join midwestapp.dbo.PJPROJEX x with (nolock)
	on ip.project = x.project
left join midwestapp.dbo.xClientContact xc with (nolock)
	on ip.user2 = xc.EA_ID 
--!!!!!! ALL FILTER CRITERIA MUST BE ON IP AND NOT P OR PARENT CHILD JOBS WILL NOT ALWAYS BE PULLED TOGETHER!!!!!!
where coalesce(ltrim(rtrim(ip.Project)),'') = case when @sProject = '' then coalesce(ltrim(rtrim(ip.Project)),'') else @sProject end
	and coalesce(ltrim(rtrim(ip.purchase_order_num)),'') = case when @sClientPO	= '' then  coalesce(ltrim(rtrim(ip.purchase_order_num)),'') else @sClientPO end

--FJR query.  To get down to one line for reporting pulling as main source
insert ##Midfjr
(
	Project,
	OpenPO,
	Actuals,
	BTD
)
select m.Project,
	OpenPO = coalesce((max(m.ExtCost) - max(m.CostVouched)),0), 
	--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
	Actuals = sum (case when m.AcctGroupCode in ('WA','WP','CM','FE') then
						m.AmountBF + m.Amount01 + m.Amount02 + m.Amount03 + m.Amount04 + m.Amount05 + m.Amount06 + m.Amount07 + m.Amount08 + m.Amount09 + m.Amount10 + m.Amount11 + m.Amount12 + m.Amount13 + m.Amount14 + m.Amount15
						else 0  
					end), 
	--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
	BTD = SUM (case when m.ControlCode = 'BTD' or AcctGroupCode = 'PB' then
					m.AmountBF + m.Amount01 + m.Amount02 + m.Amount03 + m.Amount04 + m.Amount05 + m.Amount06 + m.Amount07 + m.Amount08 + m.Amount09 + m.Amount10 + m.Amount11 + m.Amount12 + m.Amount13 + m.Amount14 + m.Amount15
					else 0  
				end) 
from midwestapp.dbo.xvr_PA924_Main m with (nolock)
inner join ##MidUni123 u
	on m.project = u.project
where m.FSYearNum = cast(@iYear as varchar) 
group by m.Project   


/*Using Current Locked Estimate view with functions.  Must roll up to project or cartestion joins */
insert ##MidfjrSums
(
	Project,
	SumType,
	SumValue
)
select CLE.Project,
	SumType = 'CLEFee',
	SumValue = sum(case when(FC.code_group = 'FEE' and FC.code_ID <> '00975') then CLE.CLEAmount else 0 end)	
from midwestapp.dbo.xvr_Est_CLE CLE with (nolock)
inner join midwestapp.dbo.xIGFunctionCode FC with (nolock)
	on CLE.pjt_entity = FC.code_ID
inner join ##MidUni123 u
	on cle.project = u.project
group by CLE.Project


insert ##MidfjrSums
(
	Project,
	SumType,
	SumValue
)
select CLE.Project,
	SumType = 'CLEAmount',
	SumValue = SUM(CLE.CLEAmount) 
from midwestapp.dbo.xvr_Est_CLE CLE 
inner join midwestapp.dbo.xIGFunctionCode FC with (nolock)
	on CLE.pjt_entity = FC.code_ID
group by CLE.Project


 -- Get the Travel Actuals
insert ##MidfjrSums
(
	Project,
	SumType,
	SumValue
)
select act.project,
	SumType = 'TRAVActuals',
	SumValue = sum(act.Amount01 + act.Amount02 + act.Amount03 + act.Amount04 + act.Amount05 + act.Amount06 + act.Amount07 + act.Amount08 + act.Amount09 + act.Amount10 + act.Amount11 + act.Amount12 + act.Amount13 + act.Amount14 + act.Amount15)
from midwestapp.dbo.xvr_BU96C_Actuals act
inner join midwestapp.dbo.xIGFunctionCode fc with (nolock)
	on act.[function] = fc.code_id
	and fc.code_group = 'TRAV'
inner join ##MidUni123 u
	on act.project = u.project
where act.acct = 'Billable'
group by act.project

-- Get the Out of Pocket Actuals
insert ##MidfjrSums
(
	Project,
	SumType,
	SumValue
)
select act.project, 
	SumType = 'OOPActuals',
	SumValue = sum(act.Amount01 + act.Amount02 + act.Amount03 + act.Amount04 + act.Amount05 + act.Amount06 + act.Amount07 + act.Amount08 + act.Amount09 + act.Amount10 + act.Amount11 + act.Amount12 + act.Amount13 + act.Amount14 + act.Amount15)
from midwestapp.dbo.xvr_BU96C_Actuals act with (nolock) 
inner join midwestapp.dbo.xIGFunctionCode fc with (nolock)
	on act.[function] = fc.code_id
inner join ##MidUni123 u
	on act.project = u.project
where act.acct IN ('Billable','BILLABLE APS','BILLABLE FEES') 
	and (coalesce(fc.code_group,'') not in ('TRAV','FEE') 
		or coalesce(fc.code_id,'') = '00975')
group by act.project  


--Per Email, include all WIP transactions.  Leaving in as easy to uncomment if decisions change.	   
insert ##MidfjrSums
(
	Project,
	SumType,
	SumValue
)
select d.Project,
	 SumType = 'WIPOvr60Amount',
	 SumValue = sum(case when d.li_type NOT IN ('D', 'A') AND DateDiff(day, d.source_trx_date, GETDATE()) > 60 then d.amount
							else 0
						end) 						
from ##MidUni123 u
inner join midwestapp.dbo.PJINVDET d with (nolock)
	on u.project = d.project
left join midwestapp.dbo.PJINVHDR h with (nolock)
	ON d.draft_num = h.draft_num
inner join midwestapp.dbo.PJPROJ p with (nolock)
	ON d.project = p.project 
inner join midwestapp.dbo.PJACCT a with (nolock)
	ON d.acct = a.acct
left join midwestapp.dbo.xWIPAgingException ae with (nolock)
	on p.project = ae.JobId
where d.hold_status <> 'PG' 
	and d.bill_status <> 'B'
	and a.acct_group_cd not in ('CM', 'FE')
	and (substring(d.acct, 1, 6) <> 'OFFSET' 
		or d.acct = 'OFFSET PREBILL')
	and ae.JobId is null
group By d.project	

insert ##MidfjrSums
(
	Project,
	SumType,
	SumValue
)
select t.project,
	SumType = 'TTLHrs',
	SumValue = sum(t.units) 
from midwestapp.dbo.PJTRAN t with (nolock)
inner join ##MidUni123 u
	on t.project = u.project
where t.acct = 'LABOR'
group By t.Project 
	
select Project = ltrim(rtrim(u.Project)), 
	[Status] = ltrim(rtrim(u.[Status])),  
	project_billwith = ltrim(rtrim(u.project_billwith)), 
	ClientID = ltrim(rtrim(u.ClientID)), 
	ClientName = ltrim(rtrim(u.ClientName)), 
	ProductID = ltrim(rtrim(u.ProductID)), 
	ProductDesc = ltrim(rtrim(u.ProductDesc)), 
	PM = ltrim(rtrim(u.PM)), 
	AcctService = ltrim(rtrim(u.AcctService)), 
	Project_Desc = ltrim(rtrim(u.Project_Desc)), 
	ClientContact = ltrim(rtrim(u.ClientContact)), 
	ContactEmailAddress = ltrim(rtrim(u.ContactEmailAddress)),
	ClientRefNo = ltrim(rtrim(u.ClientRefNo)),
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
	ProjectStatus = ltrim(rtrim(ProjectStatus)), 
	FltClientPO = ltrim(rtrim(u.FltClientPO)),
	ContractType = ltrim(rtrim(u.ContractType)),	
	ParentFlag = case when u.project_billwith <> '' and u.project_billwith = u.Project then 1 else 0 end,
	u.RowId		
from ##MidUni123 u
--Unlocked Estimate view by project
left outer join midwestapp.dbo.xvr_Est_ULE_Project ULE with (nolock)
	on u.Project = ULE.Project
left outer join ##Midfjr FJR 
	on u.project = FJR.Project
left outer join ##MidfjrSums CleFee
	on u.Project = CleFee.Project
	and CleFee.SumType = 'CLEFee'		
left outer join ##MidfjrSums CleAmount 
	ON u.Project = CleAmount.Project
	and CleAmount.SumType = 'CLEAmount'
/*Using Travel with functions.  Must roll up to project or cartestion joins */
left outer join ##MidfjrSums trv
	on u.Project = trv.Project
	and trv.SumType = 'TRAVActuals'
/*Using Out Of Pocket functions. This is all functions except TRAV and FEE Must roll up to project or cartestion joins */
left outer join ##MidfjrSums OOP
	on u.Project = OOP.Project
	and OOP.SumType = 'OOPActuals'  
/*Logic taken from BI902 and stripped down.  Including aging days for reuse*/	    
left outer join ##MidfjrSums RptWIP
	on u.Project = RptWip.project
	and rptWip.SumType =  'WIPOvr60Amount'
--Time query taken from Client P&L
left outer join ##MidfjrSums ProjectHrs 
	on u.Project = ProjectHrs.project
	and ProjectHrs.SumType = 'TTLHrs'
order by ltrim(rtrim(u.ClientID)), ltrim(rtrim(u.PM)), ltrim(rtrim(u.ProductID)), ltrim(rtrim(u.Project))
--order by u.RowId

drop table ##Midfjr
drop table ##MidfjrSums 
drop table ##MidUni123 

/*

execute midwestapp.dbo.AcctLeadershipFjrRpt @sClientId = '1LFSU', @sProductId = 'TRDE', @sPM = 'SAPPEL', @sStatus = 'A'

execute midwestapp.dbo.AcctLeadershipFjrRpt @sClientId = '1LFSU|1JJVC', @sProductId = 'TRDE|JJHW', @sPM = 'SAPPEL|MMULDOON', @sStatus = 'A|I'
*/



--drop table ##midfjrResults
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