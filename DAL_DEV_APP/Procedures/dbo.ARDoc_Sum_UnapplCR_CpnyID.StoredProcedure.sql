USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Sum_UnapplCR_CpnyID]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Sum_UnapplCR_CpnyID    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[ARDoc_Sum_UnapplCR_CpnyID] @parm1 varchar ( 15), @parm2 varchar ( 10) As
 Select SUM(DocBal) from ARDoc WHERE
 ARDoc.CustId = @parm1
 AND ARDoc.CpnyID = @parm2
 AND ARDoc.DocType IN ('PA', 'CM', 'DA') AND ARDoc.DocBal > 0
 AND ARDoc.Rlsed = 1
GO
