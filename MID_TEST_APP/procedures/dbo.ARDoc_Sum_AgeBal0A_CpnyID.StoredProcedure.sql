USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Sum_AgeBal0A_CpnyID]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Sum_AgeBal0A_CpnyID    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[ARDoc_Sum_AgeBal0A_CpnyID] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 smalldatetime, @parm4 varchar ( 6) As
 Select SUM(DocBal) from ARDoc WHERE ARDoc.CustId = @parm1
 AND ARDoc.CpnyID = @parm2
 AND ARDoc.Rlsed = 1
 AND ARDoc.DueDate >= @parm3
 AND ARDoc.DocType IN ('IN','DM','FI')
 AND ARDoc.DocBal > 0
 AND ARDoc.PerPost <= @parm4
GO
