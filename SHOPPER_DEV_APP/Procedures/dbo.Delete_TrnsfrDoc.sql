USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_TrnsfrDoc]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Delete_TrnsfrDoc]
    @parm1 varchar ( 10)
as
Delete from TrnsfrDoc
    Where BatNbr Not In
      (Select Batnbr from batch
	  Where Module = 'IN'
            And Cpnyid = @Parm1)
GO
