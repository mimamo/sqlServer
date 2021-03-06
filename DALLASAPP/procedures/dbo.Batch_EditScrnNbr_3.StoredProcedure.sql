USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_EditScrnNbr_3]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_EditScrnNbr_3    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_EditScrnNbr_3] @parm1 varchar ( 5), @parm2 varchar ( 5),@parm3 varchar (5), @parm4 varchar ( 2), @parm5 varchar ( 10) as
       Select * from Batch
           where (EditScrnNbr = @parm1 OR EditScrnNbr = @parm2 OR EditScrnNbr = @parm3)

             and module = @parm4
             and BatNbr like @parm5
                        and Status <> 'K'
                        and Status <> 'R'
           order by BatNbr
GO
