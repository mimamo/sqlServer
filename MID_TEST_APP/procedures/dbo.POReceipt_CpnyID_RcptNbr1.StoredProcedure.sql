USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_CpnyID_RcptNbr1]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_CpnyID_RcptNbr1    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_CpnyID_RcptNbr1] @parm1 varchar ( 10), @parm2 varchar ( 10) As
Select * From POReceipt
Where  CpnyId = @parm1 And
POReceipt.RcptNbr LIKE @parm2
Order By  POReceipt.RcptNbr
GO
