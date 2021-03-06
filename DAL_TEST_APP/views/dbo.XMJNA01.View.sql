USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[XMJNA01]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[XMJNA01] 
as
select
  rp.ri_id,
  t.project projectid,
  max(t.fiscalno) fiscalno,
  max(t.trans_date) trans_date
from rptruntime rp
  cross join pjtran t

where t.acct in ('DIRECT SALARY','FREELANCE','NEW BUSINESS','SEA','WIP PRODUCTION','WIP TALENT','WIP TRAVEL',
  'WIP ST HARD COST','WIP INTERACTIVE') and
  t.fiscalno <= begpernbr
group by ri_id, t.project
GO
