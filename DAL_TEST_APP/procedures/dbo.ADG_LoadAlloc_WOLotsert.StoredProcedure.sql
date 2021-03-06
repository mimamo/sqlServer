USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_WOLotsert]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ADG_LoadAlloc_WOLotsert]
	@WONnbr		Varchar(16),
	@LineRef	Varchar(5),
        @pTask          Varchar(32)

As

SELECT	TranLineRef, InvtID, SiteID, WhseLoc, LotSerNbr,
	-InvtMult*Qty, convert(float, 1), 'M'
	FROM	WOLotsert  (NOLOCK)
	WHERE	WONbr = @WONnbr
		AND TaskID = @pTask AND TranSDType = 'D' AND TranLineRef = @LineRef AND TranType = 'MR' AND status <> 'R'
GO
