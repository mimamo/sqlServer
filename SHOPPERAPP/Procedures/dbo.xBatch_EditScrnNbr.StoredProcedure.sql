USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xBatch_EditScrnNbr]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[xBatch_EditScrnNbr] @parm1 varchar ( 5), @parm2 varchar ( 10) as
       Select * from Batch
           where EditScrnNbr =    @parm1
             and BatNbr      like @parm2
			 and Status <> 'V'
           order by EditScrnNbr, BatNbr
GO
