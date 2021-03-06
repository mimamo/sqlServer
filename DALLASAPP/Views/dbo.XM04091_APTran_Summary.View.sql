USE [DALLASAPP]
GO
/****** Object:  View [dbo].[XM04091_APTran_Summary]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create VIEW [dbo].[XM04091_APTran_Summary] AS

Select
  ri_id,
  PONbr,
  POLineRef,
  Sum(AdjTranAmt) Vouch_Total
  from XM04091_APTran_Detail
  group by ri_id, PONbr, POLineRef
GO
