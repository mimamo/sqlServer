USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[XM04091_APTran]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[XM04091_APTran] AS 

Select
  ri_id,
  PONbr,
  POLineRef,
  Sum(TranAmt) Vouch_Total
from rptruntime
  cross join APTran
  where PerPost <= begpernbr
--and ri_id = '593'
  group by ri_id, PONbr, POLineRef
GO
