USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR_Batch_Recon_CA]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[AR_Batch_Recon_CA] @parm1 smalldatetime, @parm2 varchar ( 10), @parm3 varchar (10), @parm4 varchar (24) as
Select * from batch
Where module = 'AR'
and ((Cleared = 0 and DateEnt <= @parm1)
or (Cleared <> 0 and DateEnt <= @parm1 and DateClr > @parm1))
and CpnyID = @parm2
and BankAcct = @parm3
and BankSub = @parm4
and Rlsed = 1
Order by Batnbr
GO
