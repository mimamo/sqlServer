USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_DedSeq]    Script Date: 12/21/2015 15:55:24 ******/
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
