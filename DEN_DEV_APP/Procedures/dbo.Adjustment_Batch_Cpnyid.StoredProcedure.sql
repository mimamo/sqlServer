USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Adjustment_Batch_Cpnyid]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Adjustment_Batch_Cpnyid]
     @parm1 varchar ( 10),
     @Parm2 Varchar ( 10)
as
     Select * from Batch
        where EditScrnNbr IN  ('10030','10397','10530','11530')
          And Cpnyid = @Parm1
          And BatNbr like @parm2
     Order by BatNbr
GO
