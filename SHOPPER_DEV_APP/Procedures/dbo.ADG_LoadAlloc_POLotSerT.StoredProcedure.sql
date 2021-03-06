USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_POLotSerT]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_POLotSerT]
	@BatNbr		Varchar(10),
	@RcptNbr	Varchar(10),
	@INTranLineRef	Varchar(5)
As

SELECT	INTranLineRef, InvtID, SiteID, WhseLoc, LotSerNbr,
	Qty, CONVERT(FLOAT,1), 'M'
	FROM	LotSerT (NOLOCK)
	WHERE	BatNbr = @BatNbr
		AND RefNbr = @RcptNbr
		AND Rlsed = 0 AND INTranLineRef = @INTranLineRef
GO
