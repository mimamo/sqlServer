USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APAdjust_Select_VC]    Script Date: 12/21/2015 13:35:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[APAdjust_Select_VC] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10)as
Select * from APAdjust
Where adjgacct = @parm1
and adjgsub = @parm2
and adjgrefnbr = @parm3
Order by adjgrefnbr, adjbatnbr
GO
