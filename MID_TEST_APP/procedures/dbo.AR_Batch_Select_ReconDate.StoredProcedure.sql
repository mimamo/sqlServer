USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR_Batch_Select_ReconDate]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AR_Batch_Select_ReconDate    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[AR_Batch_Select_ReconDate] @parm1 smalldatetime, @parm2 smalldatetime as
Select * from batch
Where module = 'AR'
and ((Cleared = 0 and DateEnt <= @parm1)
or (Cleared <> 0 and (DateClr <= @parm1 and DateClr > @parm2)))
and Rlsed = 1
Order by Batnbr
GO
