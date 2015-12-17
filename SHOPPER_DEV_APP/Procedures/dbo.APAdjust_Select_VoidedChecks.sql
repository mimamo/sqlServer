USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APAdjust_Select_VoidedChecks]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[APAdjust_Select_VoidedChecks] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10), @parm4 as smalldatetime as
Select * from APAdjust
Where adjgacct = @parm1
and adjgsub = @parm2
and adjgrefnbr = @parm3
and adjgDocDate <= @parm4
Order by adjgrefnbr, adjbatnbr
GO
