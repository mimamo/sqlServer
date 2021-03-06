USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmfas02_Actuals]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmfas02_Actuals] 
as
select
  p.customer Client,
  t.project Job,
  p.project_desc,
  p.status_pa,
  t.trans_date,
  t.pjt_entity FunctionCode,
  t.amount ActualAmt
from pjtran t
left outer join pjproj p
on t.project = p.project

where acct = 'BILLABLE' or acct = 'BILLABLE HOURS' or acct = 'BILLABLE TAX' or acct = 'BILLABLE MARKUP'
GO
