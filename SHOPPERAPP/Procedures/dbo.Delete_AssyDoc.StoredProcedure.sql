USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_AssyDoc]    Script Date: 12/21/2015 16:13:05 ******/
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
