USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[XMJNA00]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[XMJNA00] 
as
select
  rp.ri_id,
  t.projectid,
  t.fiscalno,
  t.trans_date,
  p.start_date open_date
from rptruntime rp
  join XMJNA01 t on
  t.ri_id = rp.ri_id
  left outer join pjproj p
  on t.projectid = p.project
  where p.status_pa = 'A'
GO
