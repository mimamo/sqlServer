USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetQtyAvail_Location]    Script Date: 12/21/2015 16:00:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_GetQtyAvail_Location]
	@InvtID		Varchar(30),
	@SiteID		Varchar(10),
	@WhseLoc	Varchar(10)
As

SELECT	QtyAvail
	FROM	Location (NOLOCK)
	WHERE	InvtID = @InvtID AND SiteID = @SiteID AND WhseLoc = @WhseLoc
GO
