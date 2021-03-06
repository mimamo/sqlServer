USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_POTran]    Script Date: 12/21/2015 16:00:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_POTran]
	@BatNbr		Varchar(10),
	@RcptNbr	Varchar(10)
As

SELECT	POTRan.LineRef, POTRan.InvtID, POTRan.SiteID, POTRan.WhseLoc, SPACE(25),
	POTRan.Qty, POTRan.CnvFact, POTRan.UnitMultDiv
	FROM	POReceipt (NOLOCK)
	JOIN	POTran (NOLOCK)
	ON	POReceipt.RcptNbr = POTRan.RcptNbr
	WHERE	POReceipt.BatNbr = @BatNbr
		AND POReceipt.RcptNbr LIKE @RcptNbr
		AND POReceipt.Rlsed = 0 AND POTran.PurchaseType = 'GI'
		AND POTran.TranType = 'X'
GO
