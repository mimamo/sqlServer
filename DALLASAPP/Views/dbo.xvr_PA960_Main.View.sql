USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA960_Main]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA960_Main]

as
select 
p.pm_id01 as 'CustomerCode',
isnull(c.[name],'Customer Name Unavailable') as 'CustomerName',
p.pm_id02 as 'ProductCode',
isnull(bcyc.code_value_desc,'') as 'ProductDesc',
p.project as 'Project',
p.contract_type as 'JobCat',
p.project_desc as 'ProjectDesc',
p.purchase_order_num as 'PONumber',
p.status_pa as 'StatusPA',
p.start_date as 'StartDate',
p.end_date AS 'OnShelfDate', 
p.pm_id08 AS 'CloseDate',
isnull(est.EstimateAmountEAC,0) as 'EstimateAmountEAC',
isnull(est.EstimateAmountFAC,0) as 'EstimateAmountFAC',
isnull(est.EstimateAmountTotal,0) as 'EstimateAmountTotal',
isnull(act.Acct,'') as 'ActAcct',
isnull(act.Amount01,0) as 'Amount01',
isnull(act.Amount02,0) as 'Amount02',
isnull(act.Amount03,0) as 'Amount03',
isnull(act.Amount04,0) as 'Amount04',
isnull(act.Amount05,0) as 'Amount05',
isnull(act.Amount06,0) as 'Amount06',
isnull(act.Amount07,0) as 'Amount07',
isnull(act.Amount08,0) as 'Amount08',
isnull(act.Amount09,0) as 'Amount09',
isnull(act.Amount10,0) as 'Amount10',
isnull(act.Amount11,0) as 'Amount11',
isnull(act.Amount12,0) as 'Amount12',
isnull(act.Amount13,0) as 'Amount13',
isnull(act.Amount14,0) as 'Amount14',
isnull(act.Amount15,0) as 'Amount15',
isnull(act.AmountBF,0) as 'AmountBF',
isnull(act.FSYearNum,'1900') as 'FSYearNum',
isnull(act.AcctGroupCode,'') as 'AcctGroupCode',
isnull(act.ControlCode,'') as 'ControlCode',
p.manager1 as 'PM'
from pjproj p
left outer join customer c on p.pm_id01=c.custid
left outer join pjcode bcyc on p.pm_id02=bcyc.code_value and bcyc.code_type='BCYC'
left outer join xvr_PA960_Estimates est on p.project=est.project
left outer join xvr_PA960_Actuals act on p.project=act.project

--select * from pjcontrl where control_type='PA'
GO
