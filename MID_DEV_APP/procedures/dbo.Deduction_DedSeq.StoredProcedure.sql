USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_DedSeq]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Deduction_DedSeq] @parm1 varchar ( 10), @parm2 smallint as
        Select * from Deduction
           where DedType = 'X'
             and DedId <> @parm1
             and DedSequence = @parm2
           order by DedId
GO
