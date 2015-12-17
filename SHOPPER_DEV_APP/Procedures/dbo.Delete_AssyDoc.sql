USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_AssyDoc]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Delete_AssyDoc]
    @parm1 varchar ( 10)
as
Delete from AssyDoc
    Where BatNbr Not In
      (Select Batnbr from batch
	  Where Module = 'IN'
            And Cpnyid = @Parm1)
GO
