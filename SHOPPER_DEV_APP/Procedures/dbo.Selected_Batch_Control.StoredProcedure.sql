USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Selected_Batch_Control]    Script Date: 12/21/2015 14:34:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Selected_Batch_Control]
       @parm1 varchar (2),
       @parm2 varchar (10),
       @parm3 varchar (10),
       @parm4 varchar (10)
as
    Select * from Batch
       where Module  = @parm1
         And CpnyId LIKE @parm2
         And BatNbr Between @Parm3 and @Parm4
         And Rlsed = 1
         And ((Status IN ('P','U', 'C') and Module <> 'PO') or (Status = 'C' and Module = 'PO'))
       Order By BatNbr
GO
