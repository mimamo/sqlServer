USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetQtyAvail_LotSerMst]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_GetQtyAvail_LotSerMst]
	@InvtID		Varchar(30),
	@SiteID		Varchar(10),
	@WhseLoc	Varchar(10),
	@LotSerNbr	Varchar(25)
As

SELECT	SUM(QtyAvail)
	FROM	LotSerMst (NOLOCK)
	WHERE	InvtID = @InvtID AND SiteID = @SiteID AND WhseLoc LIKE @WhseLoc AND LotSerNbr LIKE @LotSerNbr
GO
