USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetQtyAvail_ItemSite]    Script Date: 12/21/2015 13:44:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_GetQtyAvail_ItemSite]
	@InvtID		Varchar(30),
	@SiteID		Varchar(10)
As

SELECT	QtyAvail
	FROM	ItemSite (NOLOCK)
	WHERE	InvtID = @InvtID AND SiteID = @SiteID
GO
