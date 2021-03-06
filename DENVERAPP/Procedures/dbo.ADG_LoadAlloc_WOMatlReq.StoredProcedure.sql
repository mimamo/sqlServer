USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_WOMatlReq]    Script Date: 12/21/2015 15:42:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[ADG_LoadAlloc_WOMatlReq]
	@WONnbr		Varchar(16),
        @pTask          Varchar(32)
As

SELECT	LineRef, InvtID, SiteID,WhseLoc, SPACE(25),
	QtyToIssue, QtyRemaining, CnvFact, 'M'
	FROM	WOMatlReq (NOLOCK)
	WHERE	WONbr = @WONnbr AND Task = @pTask
GO
