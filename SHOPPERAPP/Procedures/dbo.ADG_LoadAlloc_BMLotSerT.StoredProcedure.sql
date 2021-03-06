USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_BMLotSerT]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_BMLotSerT]
	@BatNbr		Varchar(10),
	@RefNbr		Varchar(10),
	@INTranLineRef	Varchar(5)
As

SELECT	INTranLineRef, InvtID, SiteID, WhseLoc, LotSerNbr,
	Qty, CONVERT(FLOAT,1), 'M'
	FROM	LotSerT (NOLOCK)
	WHERE	BatNbr = @BatNbr
		AND RefNbr = @RefNbr
		AND Rlsed = 0 AND INTranLineRef = @INTranLineRef
GO
