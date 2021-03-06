USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR_Batch_Select_ReconDate_CA]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AR_Batch_Select_ReconDate_CA    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[AR_Batch_Select_ReconDate_CA] @parm1 smalldatetime, @parm2 smalldatetime, @parm3 varchar ( 10), @parm4 varchar (10), @parm5 varchar (24) as
Select * from batch
Where module = 'AR'
and ((Cleared = 0 and DateEnt <= @parm1)
or (Cleared <> 0 and DateEnt <= @parm1 and DateClr > @parm2))
and CpnyID = @parm3
and BankAcct = @parm4
and BankSub = @parm5
and Rlsed = 1
Order by Batnbr
GO
