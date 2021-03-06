USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmfcc00]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmfcc00] 
as
select
  p.customer client,
  t.project job,
  p.project_desc,
  p.status_pa,
  t.trans_date,
  t.fiscalno,
  t.pjt_entity function_code,
  t.gl_acct,
  t.system_cd,
  t.amount,
  e.revid,
  e.amount est_amount
from pjtran t
left outer join pjacct a
on t.acct = a.acct
left outer join pjproj p
on t.project = p.project
join pjprojex x
on t.project = x.project
left outer join pjrevcat e
on t.project = e.project and t.pjt_entity = e.pjt_entity and x.pm_id25 = e.revid and e.acct = 'ESTIMATE'
where (a.acct_type = 'EX' or a.acct_type = 'AS')
GO
