USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_INTran]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_INTran]
	@BatNbr		Varchar(10),
	@RefNbr		Varchar(15) = '%'
As

SELECT	LineRef, InvtID, SiteID, WhseLoc, SPACE(25),
	-InvtMult*Qty, CnvFact, UnitMultDiv
	FROM	INTran (NOLOCK)
	WHERE	BatNbr = @BatNbr AND RefNbr LIKE @RefNbr
		AND Rlsed = 0 AND S4Future09 = 0
		AND (TranType IN ('II','IN','DM','TR')
		OR TranType = 'AS' AND InvtMult = -1
		OR TranType = 'AJ' AND Qty < 0)
GO
