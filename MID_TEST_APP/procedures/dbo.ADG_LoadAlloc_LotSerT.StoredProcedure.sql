USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_LotSerT]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_LotSerT]
	@BatNbr		Varchar(10),
	@INTranLineRef	Varchar(5),
	@RefNbr		Varchar(15) = '%'
As

SELECT	INTranLineRef, InvtID, SiteID, WhseLoc, LotSerNbr,
	-InvtMult*Qty, CONVERT(FLOAT,1), 'M'
	FROM	LotSerT (NOLOCK)
	WHERE	BatNbr = @BatNbr AND RefNbr LIKE @RefNbr
		AND Rlsed = 0 AND INTranLineRef = @INTranLineRef
GO
