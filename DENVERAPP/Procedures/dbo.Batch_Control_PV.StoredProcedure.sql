USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Control_PV]    Script Date: 12/21/2015 15:42:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Batch_Control_PV]
   @Parm1 Char(2),
   @Parm2 Char(10),
   @Parm3 Char(10)
as

Select * From Batch
   Where Module = @Parm1
         And Cpnyid = @Parm2
         And BatNbr LIKE @Parm3
         And Rlsed = 1
         And ((Status IN ('P', 'C', 'U') and Module <> 'PO') or (Status = 'C' and Module = 'PO'))
   Order By BatNbr
GO
