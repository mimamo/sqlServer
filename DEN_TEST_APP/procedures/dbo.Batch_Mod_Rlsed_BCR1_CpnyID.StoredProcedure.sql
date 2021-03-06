USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Mod_Rlsed_BCR1_CpnyID]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Mod_Rlsed_BCR1_CpnyID    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Mod_Rlsed_BCR1_CpnyID] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3 varchar ( 10), @parm4 varchar ( 10) as
       Select * from Batch
           where Module  = @parm1
             and CpnyId = @parm2
                 and Rlsed = 1
             and BatNbr between @parm3 and @parm4
	     and Status <> 'V'
           order by Module, Rlsed, BatNbr
GO
