USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSer_Tran_Hist]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSer_Tran_Hist]
	@BatNbr		char(10),
	@INTranLineRef	char(5)
as
	Select	*
	from	LotSerT
	Where	BatNbr = @BatNbr
	  and	INTranLineRef = @INTranLineRef
	Order by
		LotSerNbr,
		RecordID
GO
