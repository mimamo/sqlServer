USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_RcptNbr]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_RcptNbr    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_RcptNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) As
Select distinct poreceipt.* From POReceipt
inner join potran on potran.rcptnbr = poreceipt.ponbr
Where potran.PONbr = @parm1 And POReceipt.RcptNbr = @parm2 And POReceipt.Rlsed = 0
Order By POReceipt.PONbr, POReceipt.RcptNbr
GO
