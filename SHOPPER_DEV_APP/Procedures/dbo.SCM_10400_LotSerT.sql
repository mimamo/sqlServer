USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_LotSerT]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_LotSerT]
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10),
	@INTranLineRef	Char(5),
	@SiteID		VarChar(10),
	@TranType	Char(2)
As
/*	Set	NoCount On  */

	Select	*
		From	LotSerT
		Where	BatNbr = @BatNbr
			And CpnyID = @CpnyID
			And INTranLineRef = @INTranLineRef
			And SiteID = @SiteID
			And TranType = @TranType
GO
