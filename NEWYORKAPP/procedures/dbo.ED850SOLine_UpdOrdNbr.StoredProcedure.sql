USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SOLine_UpdOrdNbr]    Script Date: 12/21/2015 16:00:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SOLine_UpdOrdNbr] @CpnyId varchar(10), @OldOrdNbr varchar(15), @NewOrdNbr varchar(15)
As
	Update ED850SOLine
	Set OrdNbr = @NewOrdNbr
	Where 	CpnyId = @CpnyId And
		OrdNbr = @OldOrdNbr
GO
