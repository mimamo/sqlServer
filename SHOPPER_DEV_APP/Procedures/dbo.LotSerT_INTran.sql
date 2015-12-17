USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_INTran]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[LotSerT_INTran]
	@BatNbr			Varchar(10),
	@CpnyID			Varchar(10),
	@INTranLineRef		Char(5),
	@InvtID			Varchar(21),
	@SiteID			Varchar(10),
	@WhseLoc		Varchar(10)
As
	Select	*
		From	LotSerT
		Where	BatNbr = @BatNbr
			And CpnyID = @CpnyID
			And INTranLineRef = @INTranLineRef
			And InvtID = @InvtID
			And SiteID = @SiteID
			And WhseLoc = @WhseLoc
			And Rlsed = 0
		Order By RecordID
GO
