USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_TrnsfrDoc_BatNbr]    Script Date: 12/21/2015 16:13:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Delete_TrnsfrDoc_BatNbr] @parm1 varchar ( 10) as

    Exec Delete_LotSerT_BatNbr @Parm1

    Delete INTran
           from INTran
	   where BatNbr = @parm1

    Delete TrnsfrDoc
           from TrnsfrDoc
           where BatNbr = @parm1
GO
