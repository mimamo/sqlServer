USE [DALLASAPP]
GO
/****** Object:  View [dbo].[XM04091_PODetail]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[XM04091_PODetail] AS
Select
  A_ri_id = ISNULL(a.ri_id,'9999'),
  r.ri_id,
  p.PONbr,
  p.LineRef,
  p.CuryExtCost,
  p.ReqdDate,
  p.ProjectID,
  p.TaskID,
  Vouch_Total = ISNULL(a.Vouch_Total,0)
from rptruntime r
  cross join PurOrdDet p
  left outer join XM04091_APTran_Summary a
  on p.PONbr = a.PONbr and p.LineRef = a.POLineRef
  where p.CuryExtCost - ISNULL(a.Vouch_Total,0) >= 0.01
GO
