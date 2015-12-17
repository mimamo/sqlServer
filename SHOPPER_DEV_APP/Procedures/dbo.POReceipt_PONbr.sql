USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_PONbr]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[POReceipt_PONbr] @parm1 varchar ( 10) As
Select distinct POReceipt.* From POReceipt WITH (NoLock)
inner join potran  WITH (NoLock) on potran.rcptnbr = POReceipt.rcptnbr
Where potran.PONbr = @parm1 And POReceipt.Rlsed = 0
Order By POReceipt.PONbr, POReceipt.RcptNbr
GO
