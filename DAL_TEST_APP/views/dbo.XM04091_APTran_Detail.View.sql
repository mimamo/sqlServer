USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[XM04091_APTran_Detail]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create VIEW [dbo].[XM04091_APTran_Detail] AS

Select
  ri_id,
  PONbr,
  POLineRef,
  AdjTranAmt =
    Case
      When DrCR = 'C' Then -1*TranAmt
      Else TranAmt
    End
  from rptruntime
    cross join APTran
  where PerPost <= begpernbr
GO
