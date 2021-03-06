USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[All_Batch_Control]    Script Date: 12/21/2015 14:17:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[All_Batch_Control] @parm1 varchar (2), @parm2 varchar (10) as
       Select * from Batch
           where Module  = @parm1
             And CpnyId LIKE @parm2
             And Rlsed = 1
             And ((Status IN ('P','U', 'C') and Module <> 'PO') or (Status = 'C' and Module = 'PO'))
           order by BatNbr
GO
