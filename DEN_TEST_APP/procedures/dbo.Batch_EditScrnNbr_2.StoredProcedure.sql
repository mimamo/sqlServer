USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_EditScrnNbr_2]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_EditScrnNbr_2    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_EditScrnNbr_2] @parm1 varchar ( 5), @parm2 varchar ( 5), @parm3 varchar ( 2), @parm4 varchar ( 10) as
       Select * from Batch
           where (EditScrnNbr = @parm1 OR EditScrnNbr = @parm2)
             and module = @parm3
             and BatNbr like @parm4
           order by BatNbr
GO
