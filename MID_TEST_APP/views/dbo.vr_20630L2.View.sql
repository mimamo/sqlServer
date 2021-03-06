USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vr_20630L2]    Script Date: 12/21/2015 14:27:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vr_20630L2] as
select v.*,
miss = (CASE
WHEN v.trandate > v.recondate and v.perpost <= v.glperiod and v.status = 'P' 		THEN 'A'
WHEN v.trandate <= v.recondate and v.perpost > v.glperiod and v.status in ('U','P') 	THEN 'B'
WHEN v.trandate <= v.recondate and v.perpost <= v.glperiod and v.status = 'U' 		THEN 'C' END)
from vr_20630L1 v, casetup s (nolock)
where
v.rlsed = 1 and
v.trandate >=s.accepttransdate
GO
