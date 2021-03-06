USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_BOMTran]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_BOMTran]
	@CpnyID		Varchar(10),
	@RefNbr		Varchar(10)
As

SELECT	LineRef, CmpnentID, SiteID, WhseLoc, SPACE(25),
	CmpnentQty, CONVERT(FLOAT,1), 'M'
	FROM	BOMTran (NOLOCK)
	WHERE	CpnyID = @CpnyID
		AND RefNbr = @RefNbr
		AND CmpnentQty > 0
GO
