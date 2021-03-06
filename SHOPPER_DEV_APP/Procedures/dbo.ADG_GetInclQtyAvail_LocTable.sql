USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetInclQtyAvail_LocTable]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_GetInclQtyAvail_LocTable]
	@SiteID		Varchar(10),
	@WhseLoc	Varchar(10)
As

SELECT	InclQtyAvail
	FROM	LocTable (NOLOCK)
	WHERE	SiteID = @SiteID AND WhseLoc = @WhseLoc
GO
