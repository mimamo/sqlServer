USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_EditScrnNbr_CpnyID_2]    Script Date: 12/21/2015 15:42:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_EditScrnNbr_CpnyID_2    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_EditScrnNbr_CpnyID_2] @parm1 varchar(10), @parm2 varchar ( 5), @parm3 varchar ( 5), @parm4 varchar ( 2), @parm5 varchar ( 10) as
       Select * from Batch
           where CpnyID = @parm1
                 and (EditScrnNbr = @parm2 OR EditScrnNbr = @parm3)
             and module = @parm4
             and BatNbr like @parm5
           order by BatNbr
GO
